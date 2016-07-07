//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Michel Barbou Salvador on 05/07/16.
//  Copyright © 2016 mibarbou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        
        // crear instancia de modelo
        do{
            let json  = try loadFrom(remoteURL: "https://t.co/K9ziV0z3SJ")
//            print(json)
            
            var tagSet : Set<Tag> = Set<Tag>()
            
            var books = [Book]()
            for dict in json{
                do{
                    let book = try decode(book: dict)
                    books.append(book)
                    
                    for tag in book.tags {
                        
                        tagSet.insert(tag)
                    }
                    
                }catch{
                    print("Error al procesar \(dict)")
                }
                
            }
            
            let model = Library(books: books, tags: tagSet)
            
            let libraryVC = LibraryTableViewController(model: model)
            let libraryNAV = UINavigationController(rootViewController: libraryVC)
            
            let bookVC = BookViewController(model: model.getBookAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!)
            let bookNAV = UINavigationController(rootViewController: bookVC)
            
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [libraryNAV, bookNAV]
            splitVC.delegate = libraryVC
            libraryVC.delegate = bookVC
            
            splitVC.preferredDisplayMode = .Automatic
            
            
            window?.rootViewController = splitVC
 
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()
            return true
            
        }catch{
            fatalError("Error while loading JSON")
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

