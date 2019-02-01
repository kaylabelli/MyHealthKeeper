//
//  AppDelegate.swift
//  healthapp
//
//  Created by Melissa Heredia on 9/22/17.
//
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   static var menu_bool = true
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set("",forKey: "userNameKey")
        defaults.set(true,forKey: "monthlyNotificationStatus")
        
        
        //add observer for check in ortientation
    //    NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.rotatedDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // Override point for customization after application launch.
        return true
    }

   /*
    func rotatedDevice() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape Mode")
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait Mode")
        }
        
    }*/
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.dismissOpenAlerts()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //create database when application becomes active if not already created
        let created=DBManager.shared.createDatabase()
        //encypt database if not already encypted
        DBManager.shared.encrypt()
    //    DBManager.shared.openEncrypted()
        print("Create Database")
        print(created)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIApplication
{
    class func dismissOpenAlerts(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController)
    {
        //If it's an alert, dismiss it
        if let alertController = base as? UIAlertController
        {
            alertController.dismiss(animated: false, completion: nil)
        }
        
        //Check all children
        if base != nil
        {
            for controller in base!.children
            {
                if let alertController = controller as? UIAlertController
                {
                    alertController.dismiss(animated: false, completion: nil)
                }
            }
        }
        
        //Traverse the view controller tree
        if let nav = base as? UINavigationController
        {
            dismissOpenAlerts(base: nav.visibleViewController)
        }
        else if let presented = base?.presentedViewController
        {
            dismissOpenAlerts(base: presented)
        }
 
    }
}

