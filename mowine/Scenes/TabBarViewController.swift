//
//  TabBarViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/18/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

protocol TabbedViewCoordinator: class {
    func showSignedOutView()
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    weak var coordinator: TabbedViewCoordinator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vcs = viewControllers,
            selectedIndex >= 0 && selectedIndex < vcs.count,
            let vc = viewControllers?[selectedIndex]
        {
            return vc.preferredStatusBarStyle
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        if let vc = viewControllers?[3] as? MyAccountViewController {
            vc.delegate = self
        }
    }

    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AddWineViewController {
            let storyboard = UIStoryboard(name: "AddWine", bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
                return false
            }
        }

        return true
    }
}

extension TabBarViewController: MyAccountViewControllerDelegate {
    func didSignOut() {
        coordinator?.showSignedOutView()
    }
}
