//
//  DeviseSize.swift
//  MachingApp
//
//  Created by YUMAKOMORI on 2016/07/07.
//  Copyright © 2016年 YUMAKOMORI. All rights reserved.
//

import UIKit

class DeviseSize: NSObject {
    struct DeviseSize {
        
        //CGRectを取得
        static func bounds() ->CGRect {
            return UIScreen.mainScreen().bounds
        }
        
        //画面の横サイズを取得
        static func screenWidth() ->Int {
            return Int(UIScreen.mainScreen().bounds.size.width)
        }
        
        //画面の縦サイズを取得
        static func screenHeight() ->Int {
            return Int(UIScreen.mainScreen().bounds.size.height)
        }
        
        static func statusBarHeight() -> CGFloat {
            return UIApplication.sharedApplication().statusBarFrame.height
        }
        
        static func navBarHeight(navigationController: UINavigationController) -> CGFloat {
            return navigationController.navigationBar.frame.size.height
        }
        
        static func tabBarHeight(tabBarController: UITabBarController) -> CGFloat {
            return tabBarController.tabBar.frame.size.height
        }
        
    }
}


