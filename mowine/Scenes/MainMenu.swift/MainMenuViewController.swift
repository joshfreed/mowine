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
    
    private var showNavBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        addWineMenuItem.delegate = self
        myWinesMenuItem.delegate = self
        myAccountMenuItem.delegate = self
        friendsMenuItem.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if showNavBar {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func showAddWine() {
        showNavBar = true
        performSegue(withIdentifier: "addWine", sender: nil)
    }
    
    func showMyWines() {
        showNavBar = true
        performSegue(withIdentifier: "myWines", sender: nil)
    }
    
    func showMyAccount() {
        
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
