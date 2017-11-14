//
//  AppDelegate.swift
//  Layered App Partner
//
//  Created by Gustavo Serra on 13/11/2017.
//  Copyright © 2017 iHealthLabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        if !UserDefaults.standard.bool(forKey: "session") {
            
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignInViewController")
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "ihealth-layered-partner" {
            
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let queryItems: [URLQueryItem]? = urlComponents?.queryItems
            
            let status = queryItems?.filter { return $0.name == "status" }
            
            if status?.first?.value == "3855" {
                
                let macQueryItem = queryItems?.filter { return $0.name == "mac" }
                let resultQueryItem = queryItems?.filter { return $0.name == "result" }
                
                if let mac = macQueryItem?.first?.value {
                    
                    print("MAC: " + mac)
                    UserDefaults.standard.set(mac, forKey: "MAC_ID")
                }
                
                if let stringResult = resultQueryItem?.first?.value {
                    
                    var arrayResult: [Dictionary<String,String>]?
                    
                    if let dataResult = stringResult.data(using: .utf8) {
                        
                        do {
                            arrayResult = try JSONSerialization.jsonObject(with: dataResult, options: []) as? Array
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    if let newWeight = arrayResult?.first {
                        
                        print("Weight readed: \(String(describing: newWeight["weight"])) at \(String(describing: newWeight["measured_at"]))")
                        
                        var weights: [Dictionary<String,Any>]? = UserDefaults.standard.value(forKey: "WEIGHTS") as? [Dictionary<String,Any>]
                        
                        if let _ = weights {
                            
                            weights?.append(newWeight)
                            
                            UserDefaults.standard.set(weights, forKey: "WEIGHTS")
                        } else {
                            
                            UserDefaults.standard.set([newWeight], forKey: "WEIGHTS")
                        }
                    }
                }
                
                UserDefaults.standard.synchronize()
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let weightViewController = mainStoryboard.instantiateViewController(withIdentifier: "WeightsViewController")
                
                self.window?.rootViewController = weightViewController
                self.window?.makeKeyAndVisible()
            } else if status?.first?.value == "1" {
                
                let errorQueryItem = queryItems?.filter { return $0.name == "reason" }
                
                if let error = errorQueryItem?.first?.value {
                    
                    print("Error: " + error)
                }
            } else {
                
                print("User canceled the operation ")
            }
            
            return true
        }
        
        return false
    }
}

