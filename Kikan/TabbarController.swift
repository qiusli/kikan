//
//  TabbarController.swift
//  Kikan
//
//  Created by Qiushi Li on 2/29/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import WXTabBarController

class TabbarController: UIViewController {
    var navController: UINavigationController!
    var tabController: WXTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabController = getMyTabController()
        navController  = getMyNavigationController()

//        var mainView = UIViewController(nibName: nil, bundle: nil)
        var nav = getMyNavigationController()
//        nav.viewControllers = [mainView]
//        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
//        self.window?.rootViewController = getNavigationController()
//        self.window?.makeKeyAndVisible()
//        self.
        
    }
    
    func getMyNavigationController() -> UINavigationController {
        let navController = UINavigationController.init(rootViewController: self.tabBarController!)
        navController.navigationBar.tintColor = UIColor.init(red: 26/255.0, green: 178/255.0, blue: 10/255.0, alpha: 1)
        return navController
    }
    
    func getMyTabController() -> WXTabBarController {
        let tabBarController = WXTabBarController()
        tabBarController.title = "Weixin"
        tabBarController.tabBar.tintColor = UIColor(colorLiteralRed: 26 / 255.0, green:178 / 255.0, blue:10 / 255.0, alpha:1)
        tabBarController.viewControllers = [UINavigationController(rootViewController: getMainframeNavigationController()),
            UINavigationController(rootViewController: getContactsNavigationController())]
        return tabBarController
    }
    
    func getMainframeNavigationController() -> UIViewController {
        let mainframeViewController = UIViewController()
        
        let mainframeImage = UIImage(named: "tabbar_mainframe")
        let mainframeHLImage = UIImage(named: "tabbar_mainframeHL")
        
        mainframeViewController.title = "Weixin"
        mainframeViewController.tabBarItem = UITabBarItem.init(title: "Weixin", image: mainframeImage, selectedImage: mainframeHLImage)
        mainframeViewController.view.backgroundColor = UIColor.init(red: 48/255.0, green: 67/255.0, blue: 78/255.0, alpha: 1)
        mainframeViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_add"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didClickAddButton:"))
        
        return mainframeViewController
    }
    
    func getContactsNavigationController() -> UIViewController {
        let mainframeViewController = UIViewController()
        
        let mainframeImage = UIImage(named: "tabbar_contacts")
        let mainframeHLImage = UIImage(named: "tabbar_contactsHL")
        
        mainframeViewController.title = "contacts"
        mainframeViewController.tabBarItem = UITabBarItem.init(title: "contacts", image: mainframeImage, selectedImage: mainframeHLImage)
        mainframeViewController.view.backgroundColor = UIColor.init(red: 48/255.0, green: 67/255.0, blue: 78/255.0, alpha: 1)
        mainframeViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_add"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didClickAddButton:"))
        
        return mainframeViewController
    }
    
    func didClickAddButton(sender: AnyObject) {
        let viewController = UIViewController()
        viewController.title = "Add"
        viewController.view.backgroundColor = UIColor(colorLiteralRed: 26/255.0, green: 178/255.0, blue: 10/255.0, alpha: 1)
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}
