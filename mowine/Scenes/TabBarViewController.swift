//
//  TabBarViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/18/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    var session: Session!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        session = Container.shared.session
        Container.shared.syncManager.sync()
    }

    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AddWineViewController {
            let storyboard = UIStoryboard(name: "AddWine", bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                present(vc, animated: true, completion: nil)
                return false
            }
        }

        return true
    }
}
