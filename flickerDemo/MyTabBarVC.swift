//
//  MyTabBarVC.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import UIKit

enum VC_TYPE: Int {
    case SEARCH
    case FAVORITE
}

class MyTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
  
    @objc func refresh() {
        if let vc = self.viewControllers?[VC_TYPE.FAVORITE.rawValue] as? SecondViewController {
            vc.controller.start()
        }
    }
}

extension MyTabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch VC_TYPE.init(rawValue: tabBarController.selectedIndex) {
        case .SEARCH:
            if let firstVC = (viewController as? UINavigationController)?.viewControllers.first as? FirstViewController {
                firstVC.clearInput()
            }
            if let searchVC = viewController as? UINavigationController {
                searchVC.popToRootViewController(animated: true)
            }
        case .FAVORITE:
            break
        case .none:
            fatalError()
        }
    }
}
