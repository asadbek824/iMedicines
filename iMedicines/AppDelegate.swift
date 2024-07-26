//
//  AppDelegate.swift
//  iMedicines
//
//  Created by Asadbek Yoldoshev on 26/07/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let tabBarItemsData = [
        TabBarItemData(image: "square.and.pencil", title: "List of medicines", type: HomeViewController()),
        TabBarItemData(image: "clock", title: "History of medicines", type: MedicinesHistoryViewController())
    ]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarVC = UITabBarController()
        
        tabBarVC.viewControllers = createTabBarItems(tabBarItems: tabBarItemsData)
        tabBarVC.selectedIndex = 0
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = .appColor.primaryButton
        tabBarVC.tabBar.layer.cornerRadius = 20
        tabBarVC.tabBar.clipsToBounds = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        
        return true
    }
}

extension AppDelegate {
    
    func createTabBarItems(tabBarItems: [TabBarItemData]) -> [UIViewController] {
        var tabBars: [UIViewController] = []
        
        for item in tabBarItems {
            let vc: UIViewController = UINavigationController(rootViewController: item.type)
            
            vc.tabBarItem.title = item.title
            vc.tabBarItem.image = UIImage(systemName: item.image)
            
            tabBars.append(vc)
        }
        return tabBars
    }
}

struct TabBarItemData {
    let image: String
    let title: String
    let type: UIViewController
}

