//
//  AppDelegate.swift
//  ORSwiftSummary
//
//  Created by orilme on 2019/12/18.
//  Copyright © 2019 orilme. All rights reserved.
//  com.orilme.swift.cn

import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = self.homeController()
        self.window?.makeKeyAndVisible()
        
        DispatchQueue.main.async {
            print("APP启动时间耗时，从mian函数开始到didFinishLaunchingWithOptions方法---\(CFAbsoluteTimeGetCurrent() - appStartLaunchTime)")
        }
        
        return true
    }
    
    func homeController() -> UIViewController {
        let tabBarController = UITabBarController()
//        tabBarController.tabBar.tintColor = UIColor.purple
        let controllers = [UINavigationController(rootViewController: KnowledgePointVC()),
                           UINavigationController(rootViewController: NormalDemoVC())]
        let homeBarItem = controllers[0].tabBarItem
        homeBarItem?.title = "知识点"
        homeBarItem?.image = UIImage.init(named: "account_normal")
        homeBarItem?.selectedImage = UIImage.init(named: "account_highlight")
        let mineBarItem = controllers[1].tabBarItem
        mineBarItem?.title = "Demo"
        mineBarItem?.image = UIImage.init(named: "account_normal")
        mineBarItem?.selectedImage = UIImage.init(named: "account_highlight")
        tabBarController.viewControllers = controllers
        return tabBarController
    }

}

