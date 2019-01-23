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
/* Automatically generated.  Do not edit */
/* See the tool/mkopcodec.tcl script for details. */
#if !defined(SQLITE_OMIT_EXPLAIN) \
 || defined(VDBE_PROFILE) \
 || defined(SQLITE_DEBUG)
#if defined(SQLITE_ENABLE_EXPLAIN_COMMENTS) || defined(SQLITE_DEBUG)
# define OpHelp(X) "\0" X
#else
# define OpHelp(X)
#endif
const char *sqlite3OpcodeName(int i){
 static const char *const azName[] = {
    /*   0 */ "Savepoint"        OpHelp(""),
    /*   1 */ "AutoCommit"       OpHelp(""),
    /*   2 */ "Transaction"      OpHelp(""),
    /*   3 */ "SorterNext"       OpHelp(""),
    /*   4 */ "PrevIfOpen"       OpHelp(""),
    /*   5 */ "NextIfOpen"       OpHelp(""),
    /*   6 */ "Prev"             OpHelp(""),
    /*   7 */ "Next"             OpHelp(""),
    /*   8 */ "Checkpoint"       OpHelp(""),
    /*   9 */ "JournalMode"      OpHelp(""),
    /*  10 */ "Vacuum"           OpHelp(""),
    /*  11 */ "VFilter"          OpHelp("iplan=r[P3] zplan='P4'"),
    /*  12 */ "VUpdate"          OpHelp("data=r[P3@P2]"),
    /*  13 */ "Goto"             OpHelp(""),
    /*  14 */ "Gosub"            OpHelp(""),
    /*  15 */ "InitCoroutine"    OpHelp(""),
    /*  16 */ "Yield"            OpHelp(""),
    /*  17 */ "MustBeInt"        OpHelp(""),
    /*  18 */ "Jump"             OpHelp(""),
    /*  19 */ "Not"              OpHelp("r[P2]= !r[P1]"),
    /*  20 */ "Once"             OpHelp(""),
    /*  21 */ "If"               OpHelp(""),
    /*  22 */ "IfNot"            OpHelp(""),
    /*  23 */ "SeekLT"           OpHelp("key=r[P3@P4]"),
    /*  24 */ "SeekLE"           OpHelp("key=r[P3@P4]"),
    /*  25 */ "SeekGE"           OpHelp("key=r[P3@P4]"),
    /*  26 */ "SeekGT"           OpHelp("key=r[P3@P4]"),
    /*  27 */ "Or"               OpHelp("r[P3]=(r[P1] || r[P2])"),
    /*  28 */ "And"              OpHelp("r[P3]=(r[P1] && r[P2])"),
    /*  29 */ "NoConflict"       OpHelp("key=r[P3@P4]"),
    /*  30 */ "NotFound"         OpHelp("key=r[P3@P4]"),
    /*  31 */ "Found"            OpHelp("key=r[P3@P4]"),
    /*  32 */ "SeekRowid"        OpHelp("intkey=r[P3]"),
    /*  33 */ "NotExists"        OpHelp("intkey=r[P3]"),
    /*  34 */ "IsNull"           OpHelp("if r[P1]==NULL goto P2"),
    /*  35 */ "NotNull"          OpHelp("if r[P1]!=NULL goto P2"),
    /*  36 */ "Ne"               OpHelp("IF r[P3]!=r[P1]"),
    /*  37 */ "Eq"               OpHelp("IF r[P3]==r[P1]"),
    /*  38 */ "Gt"               OpHelp("IF r[P3]>r[P1]"),
    /*  39 */ "Le"               OpHelp("IF r[P3]<=r[P1]"),
    /*  40 */ "Lt"               OpHelp("IF r[P3]<r[P1]"),
    /*  41 */ "Ge"               OpHelp("IF r[P3]>=r[P1]"),
    /*  42 */ "ElseNotEq"        OpHelp(""),
    /*  43 */ "BitAnd"           OpHelp("r[P3]=r[P1]&r[P2]"),
    /*  44 */ "BitOr"            OpHelp("r[P3]=r[P1]|r[P2]"),
    /*  45 */ "ShiftLeft"        OpHelp("r[P3]=r[P2]<<r[P1]"),
    /*  46 */ "ShiftRight"       OpHelp("r[P3]=r[P2]>>r[P1]"),
    /*  47 */ "Add"              OpHelp("r[P3]=r[P1]+r[P2]"),
    /*  48 */ "Subtract"         OpHelp("r[P3]=r[P2]-r[P1]"),
    /*  49 */ "Multiply"         OpHelp("r[P3]=r[P1]*r[P2]"),
    /*  50 */ "Divide"           OpHelp("r[P3]=r[P2]/r[P1]"),
    /*  51 */ "Remainder"        OpHelp("r[P3]=r[P2]%r[P1]"),
    /*  52 */ "Concat"           OpHelp("r[P3]=r[P2]+r[P1]"),
    /*  53 */ "Last"             OpHelp(""),
    /*  54 */ "BitNot"           OpHelp("r[P1]= ~r[P1]"),
    /*  55 */ "SorterSort"       OpHelp(""),
    /*  56 */ "Sort"             OpHelp(""),
    /*  57 */ "Rewind"           OpHelp(""),
    /*  58 */ "IdxLE"            OpHelp("key=r[P3@P4]"),
    /*  59 */ "IdxGT"            OpHelp("key=r[P3@P4]"),
    /*  60 */ "IdxLT"            OpHelp("key=r[P3@P4]"),
    /*  61 */ "IdxGE"            OpHelp("key=r[P3@P4]"),
    /*  62 */ "RowSetRead"       OpHelp("r[P3]=rowset(P1)"),
    /*  63 */ "RowSetTest"       OpHelp("if r[P3] in rowset(P1) goto P2"),
    /*  64 */ "Program"          OpHelp(""),
    /*  65 */ "FkIfZero"         OpHelp("if fkctr[P1]==0 goto P2"),
    /*  66 */ "IfPos"            OpHelp("if r[P1]>0 then r[P1]-=P3, goto P2"),
    /*  67 */ "IfNotZero"        OpHelp("if r[P1]!=0 then r[P1]-=P3, goto P2"),
    /*  68 */ "DecrJumpZero"     OpHelp("if (--r[P1])==0 goto P2"),
    /*  69 */ "IncrVacuum"       OpHelp(""),
    /*  70 */ "VNext"            OpHelp(""),
    /*  71 */ "Init"             OpHelp("Start at P2"),
    /*  72 */ "Return"           OpHelp(""),
    /*  73 */ "EndCoroutine"     OpHelp(""),
    /*  74 */ "HaltIfNull"       OpHelp("if r[P3]=null halt"),
    /*  75 */ "Halt"             OpHelp(""),
    /*  76 */ "Integer"          OpHelp("r[P2]=P1"),
    /*  77 */ "Int64"            OpHelp("r[P2]=P4"),
    /*  78 */ "String"           OpHelp("r[P2]='P4' (len=P1)"),
    /*  79 */ "Null"             OpHelp("r[P2..P3]=NULL"),
    /*  80 */ "SoftNull"         OpHelp("r[P1]=NULL"),
    /*  81 */ "Blob"             OpHelp("r[P2]=P4 (len=P1)"),
    /*  82 */ "Variable"         OpHelp("r[P2]=parameter(P1,P4)"),
    /*  83 */ "Move"             OpHelp("r[P2@P3]=r[P1@P3]"),
    /*  84 */ "Copy"             OpHelp("r[P2@P3+1]=r[P1@P3+1]"),
    /*  85 */ "SCopy"            OpHelp("r[P2]=r[P1]"),
    /*  86 */ "IntCopy"          OpHelp("r[P2]=r[P1]"),
    /*  87 */ "ResultRow"        OpHelp("output=r[P1@P2]"),
    /*  88 */ "CollSeq"          OpHelp(""),
    /*  89 */ "Function0"        OpHelp("r[P3]=func(r[P2@P5])"),
    /*  90 */ "Function"         OpHelp("r[P3]=func(r[P2@P5])"),
    /*  91 */ "AddImm"           OpHelp("r[P1]=r[P1]+P2"),
    /*  92 */ "RealAffinity"     OpHelp(""),
    /*  93 */ "Cast"             OpHelp("affinity(r[P1])"),
    /*  94 */ "Permutation"      OpHelp(""),
    /*  95 */ "Compare"          OpHelp("r[P1@P3] <-> r[P2@P3]"),
    /*  96 */ "Column"           OpHelp("r[P3]=PX"),
    /*  97 */ "String8"          OpHelp("r[P2]='P4'"),
    /*  98 */ "Affinity"         OpHelp("affinity(r[P1@P2])"),
    /*  99 */ "MakeRecord"       OpHelp("r[P3]=mkrec(r[P1@P2])"),
    /* 100 */ "Count"            OpHelp("r[P2]=count()"),
    /* 101 */ "ReadCookie"       OpHelp(""),
    /* 102 */ "SetCookie"        OpHelp(""),
    /* 103 */ "ReopenIdx"        OpHelp("root=P2 iDb=P3"),
    /* 104 */ "OpenRead"         OpHelp("root=P2 iDb=P3"),
    /* 105 */ "OpenWrite"        OpHelp("root=P2 iDb=P3"),
    /* 106 */ "OpenAutoindex"    OpHelp("nColumn=P2"),
    /* 107 */ "OpenEphemeral"    OpHelp("nColumn=P2"),
    /* 108 */ "SorterOpen"       OpHelp(""),
    /* 109 */ "SequenceTest"     OpHelp("if( cursor[P1].ctr++ ) pc = P2"),
    /* 110 */ "OpenPseudo"       OpHelp("P3 columns in r[P2]"),
    /* 111 */ "Close"            OpHelp(""),
    /* 112 */ "ColumnsUsed"      OpHelp(""),
    /* 113 */ "Sequence"         OpHelp("r[P2]=cursor[P1].ctr++"),
    /* 114 */ "NewRowid"         OpHelp("r[P2]=rowid"),
    /* 115 */ "Insert"           OpHelp("intkey=r[P3] data=r[P2]"),
    /* 116 */ "InsertInt"        OpHelp("intkey=P3 data=r[P2]"),
    /* 117 */ "Delete"           OpHelp(""),
    /* 118 */ "ResetCount"       OpHelp(""),
    /* 119 */ "SorterCompare"    OpHelp("if key(P1)!=trim(r[P3],P4) goto P2"),
    /* 120 */ "SorterData"       OpHelp("r[P2]=data"),
    /* 121 */ "RowKey"           OpHelp("r[P2]=key"),
    /* 122 */ "RowData"          OpHelp("r[P2]=data"),
    /* 123 */ "Rowid"            OpHelp("r[P2]=rowid"),
    /* 124 */ "NullRow"          OpHelp(""),
    /* 125 */ "SorterInsert"     OpHelp(""),
    /* 126 */ "IdxInsert"        OpHelp("key=r[P2]"),
    /* 127 */ "IdxDelete"        OpHelp("key=r[P2@P3]"),
    /* 128 */ "Seek"             OpHelp("Move P3 to P1.rowid"),
    /* 129 */ "IdxRowid"         OpHelp("r[P2]=rowid"),
    /* 130 */ "Destroy"          OpHelp(""),
    /* 131 */ "Clear"            OpHelp(""),
    /* 132 */ "Real"             OpHelp("r[P2]=P4"),
    /* 133 */ "ResetSorter"      OpHelp(""),
    /* 134 */ "CreateIndex"      OpHelp("r[P2]=root iDb=P1"),
    /* 135 */ "CreateTable"      OpHelp("r[P2]=root iDb=P1"),
    /* 136 */ "ParseSchema"      OpHelp(""),
    /* 137 */ "LoadAnalysis"     OpHelp(""),
    /* 138 */ "DropTable"        OpHelp(""),
    /* 139 */ "DropIndex"        OpHelp(""),
    /* 140 */ "DropTrigger"      OpHelp(""),
    /* 141 */ "IntegrityCk"      OpHelp(""),
    /* 142 */ "RowSetAdd"        OpHelp("rowset(P1)=r[P2]"),
    /* 143 */ "Param"            OpHelp(""),
    /* 144 */ "FkCounter"        OpHelp("fkctr[P1]+=P2"),
    /* 145 */ "MemMax"           OpHelp("r[P1]=max(r[P1],r[P2])"),
    /* 146 */ "OffsetLimit"      OpHelp("if r[P1]>0 then r[P2]=r[P1]+max(0,r[P3]) else r[P2]=(-1)"),
    /* 147 */ "AggStep0"         OpHelp("accum=r[P3] step(r[P2@P5])"),
    /* 148 */ "AggStep"          OpHelp("accum=r[P3] step(r[P2@P5])"),
    /* 149 */ "AggFinal"         OpHelp("accum=r[P1] N=P2"),
    /* 150 */ "Expire"           OpHelp(""),
    /* 151 */ "TableLock"        OpHelp("iDb=P1 root=P2 write=P3"),
    /* 152 */ "VBegin"           OpHelp(""),
    /* 153 */ "VCreate"          OpHelp(""),
    /* 154 */ "VDestroy"         OpHelp(""),
    /* 155 */ "VOpen"            OpHelp(""),
    /* 156 */ "VColumn"          OpHelp("r[P3]=vcolumn(P2)"),
    /* 157 */ "VRename"          OpHelp(""),
    /* 158 */ "Pagecount"        OpHelp(""),
    /* 159 */ "MaxPgcnt"         OpHelp(""),
    /* 160 */ "CursorHint"       OpHelp(""),
    /* 161 */ "Noop"             OpHelp(""),
    /* 162 */ "Explain"          OpHelp(""),
  };
  return azName[i];
}
#endif
