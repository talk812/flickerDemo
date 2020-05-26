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

let TAB_BAR_VC = "tabbarVC"

class MyTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.selectedIndex = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init(TAB_BAR_VC), object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            if let vc = viewController as? SecondViewController {
                vc.controller.start()
            }
        case .none:
            fatalError()
        }
    }
}
