/*
** The author disclaims copyright to this source code.
**
*************************************************************************
** Implementation of the "simple" full-text-search tokenizer.
*/
/*Copyright (c) 2008, ZETETIC LLC
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the ZETETIC LLC nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*
** The code in this file is only compiled if:
**
**     * The FTS1 module is being built as an extension
**       (in which case SQLITE_CORE is not defined), or
**
**     * The FTS1 module is being built into the core of
**       SQLite (in which case SQLITE_ENABLE_FTS1 is defined).
*/
#if !defined(SQLITE_CORE) || defined(SQLITE_ENABLE_FTS1)


#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "fts1_tokenizer.h"

typedef struct simple_tokenizer {
  sqlite3_tokenizer base;
  char delim[128];             /* flag ASCII delimiters */
} simple_tokenizer;

typedef struct simple_tokenizer_cursor {
  sqlite3_tokenizer_cursor base;
  const char *pInput;          /* input we are tokenizing */
  int nBytes;                  /* size of the input */
  int iOffset;                 /* current position in pInput */
  int iToken;                  /* index of next token to be returned */
  char *pToken;                /* storage for current token */
  int nTokenAllocated;         /* space allocated to zToken buffer */
} simple_tokenizer_cursor;


/* Forward declaration */
static const sqlite3_tokenizer_module simpleTokenizerModule;

static int isDelim(simple_tokenizer *t, unsigned char c){
  return c<0x80 && t->delim[c];
}

/*
** Create a new tokenizer instance.
*/
static int simpleCreate(
  int argc, const char * const *argv,
  sqlite3_tokenizer **ppTokenizer
){
  simple_tokenizer *t;

  t = (simple_tokenizer *) calloc(sizeof(*t), 1);
  if( t==NULL ) return SQLITE_NOMEM;

  /* TODO(shess) Delimiters need to remain the same from run to run,
  ** else we need to reindex.  One solution would be a meta-table to
  ** track such information in the database, then we'd only want this
  ** information on the initial create.
  */
  if( argc>1 ){
    int i, n = strlen(argv[1]);
    for(i=0; i<n; i++){
      unsigned char ch = argv[1][i];
      /* We explicitly don't support UTF-8 delimiters for now. */
      if( ch>=0x80 ){
        free(t);
        return SQLITE_ERROR;
      }
      t->delim[ch] = 1;
    }
  } else {
    /* Mark non-alphanumeric ASCII characters as delimiters */
    int i;
    for(i=1; i<0x80; i++){
      t->delim[i] = !isalnum(i);
    }
  }

  *ppTokenizer = &t->base;
  return SQLITE_OK;
}

/*
** Destroy a tokenizer
*/
static int simpleDestroy(sqlite3_tokenizer *pTokenizer){
  free(pTokenizer);
  return SQLITE_OK;
}

/*
** Prepare to begin tokenizing a particular string.  The input
** string to be tokenized is pInput[0..nBytes-1].  A cursor
** used to incrementally tokenize this string is returned in 
** *ppCursor.
*/
static int simpleOpen(
  sqlite3_tokenizer *pTokenizer,         /* The tokenizer */
  const char *pInput, int nBytes,        /* String to be tokenized */
  sqlite3_tokenizer_cursor **ppCursor    /* OUT: Tokenization cursor */
){
  simple_tokenizer_cursor *c;

  c = (simple_tokenizer_cursor *) malloc(sizeof(*c));
  if( c==NULL ) return SQLITE_NOMEM;

  c->pInput = pInput;
  if( pInput==0 ){
    c->nBytes = 0;
  }else if( nBytes<0 ){
    c->nBytes = (int)strlen(pInput);
  }else{
    c->nBytes = nBytes;
  }
  c->iOffset = 0;                 /* start tokenizing at the beginning */
  c->iToken = 0;
  c->pToken = NULL;               /* no space allocated, yet. */
  c->nTokenAllocated = 0;

  *ppCursor = &c->base;
  return SQLITE_OK;
}

/*
** Close a tokenization cursor previously opened by a call to
** simpleOpen() above.
*/
static int simpleClose(sqlite3_tokenizer_cursor *pCursor){
  simple_tokenizer_cursor *c = (simple_tokenizer_cursor *) pCursor;
  free(c->pToken);
  free(c);
  return SQLITE_OK;
}

/*
** Extract the next token from a tokenization cursor.  The cursor must
** have been opened by a prior call to simpleOpen().
*/
static int simpleNext(
  sqlite3_tokenizer_cursor *pCursor,  /* Cursor returned by simpleOpen */
  const char **ppToken,               /* OUT: *ppToken is the token text */
  int *pnBytes,                       /* OUT: Number of bytes in token */
  int *piStartOffset,                 /* OUT: Starting offset of token */
  int *piEndOffset,                   /* OUT: Ending offset of token */
  int *piPosition                     /* OUT: Position integer of token */
){
  simple_tokenizer_cursor *c = (simple_tokenizer_cursor *) pCursor;
  simple_tokenizer *t = (simple_tokenizer *) pCursor->pTokenizer;
  unsigned char *p = (unsigned char *)c->pInput;

  while( c->iOffset<c->nBytes ){
    int iStartOffset;

    /* Scan past delimiter characters */
    while( c->iOffset<c->nBytes && isDelim(t, p[c->iOffset]) ){
      c->iOffset++;
    }

    /* Count non-delimiter characters. */
    iStartOffset = c->iOffset;
    while( c->iOffset<c->nBytes && !isDelim(t, p[c->iOffset]) ){
      c->iOffset++;
    }

    if( c->iOffset>iStartOffset ){
      int i, n = c->iOffset-iStartOffset;
      if( n>c->nTokenAllocated ){
        c->nTokenAllocated = n+20;
        c->pToken = realloc(c->pToken, c->nTokenAllocated);
        if( c->pToken==NULL ) return SQLITE_NOMEM;
      }
      for(i=0; i<n; i++){
        /* TODO(shess) This needs expansion to handle UTF-8
        ** case-insensitivity.
        */
        unsigned char ch = p[iStartOffset+i];
        c->pToken[i] = ch<0x80 ? tolower(ch) : ch;
      }
      *ppToken = c->pToken;
      *pnBytes = n;
      *piStartOffset = iStartOffset;
      *piEndOffset = c->iOffset;
      *piPosition = c->iToken++;

      return SQLITE_OK;
    }
  }
  return SQLITE_DONE;
}

/*
** The set of routines that implement the simple tokenizer
*/
static const sqlite3_tokenizer_module simpleTokenizerModule = {
  0,
  simpleCreate,
  simpleDestroy,
  simpleOpen,
  simpleClose,
  simpleNext,
};

/*
** Allocate a new simple tokenizer.  Return a pointer to the new
** tokenizer in *ppModule
*/
void sqlite3Fts1SimpleTokenizerModule(
  sqlite3_tokenizer_module const**ppModule
){
  *ppModule = &simpleTokenizerModule;
}

#endif /* !defined(SQLITE_CORE) || defined(SQLITE_ENABLE_FTS1) */
