//
//  MainMenuViewController.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import JFLib

class MainMenuViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addWineMenuItem: MenuItem!
    @IBOutlet weak var myWinesMenuItem: MenuItem!
    @IBOutlet weak var myAccountMenuItem: MenuItem!
    @IBOutlet weak var friendsMenuItem: MenuItem!
    
    var session: Session!
    var router: (NSObjectProtocol & MainMenuRoutingLogic)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let router = MainMenuRouter()
        
        viewController.session = Container.shared.session
        viewController.router = router
        
        router.viewController = viewController
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hideNavigationBar()
        
        addWineMenuItem.delegate = self
        myWinesMenuItem.delegate = self
        myAccountMenuItem.delegate = self
        friendsMenuItem.delegate = self
    }

    func showAddWine() {
        performSegue(withIdentifier: "AddWine", sender: nil)
    }
    
    func showMyWines() {
        performSegue(withIdentifier: "MyWines", sender: nil)
    }
    
    func showMyAccount() {
        if session.isLoggedIn {
            performSegue(withIdentifier: "MyAccount", sender: nil)
        } else {
            performSegue(withIdentifier: "SignIn", sender: nil)
        }
    }
    
    func showFriends() {
        
    }
}

extension MainMenuViewController: MenuItemDelegate {
    func didSelect(menuItem: MenuItem) {
        if menuItem == addWineMenuItem {
            showAddWine()
        } else if menuItem == myWinesMenuItem {
            showMyWines()
        } else if menuItem == myAccountMenuItem {
            showMyAccount()
        } else if menuItem == friendsMenuItem {
            showFriends()
        }
    }
}
