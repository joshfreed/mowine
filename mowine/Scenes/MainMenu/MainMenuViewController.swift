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
    @IBOutlet weak var newWineImage: UIImageView!
    @IBOutlet weak var myWinesImage: UIImageView!
    @IBOutlet weak var newWineView: UIView!
    @IBOutlet weak var myWinesView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var launchScreenStackView: UIStackView!
    @IBOutlet weak var launchScreenTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var launchScreenCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLineLabel: UILabel!

    private var showNavBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        newWineView.alpha = 0
        myWinesView.alpha = 0
        titleLabel.isHidden = true
        launchScreenStackView.isHidden = false
        
        newWineImage.fixTintIssue()
        myWinesImage.fixTintIssue()
        
        newWineView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedNewWine)))
        myWinesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedMyWines)))
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delay(seconds: 1) {
            self.animateLaunchScreenToMainMenu()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if showNavBar {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func animateLaunchScreenToMainMenu() {
        view.layoutIfNeeded()
        
        launchScreenCenterConstraint.isActive = false
        launchScreenTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.1) {
            self.tagLineLabel.alpha = 0
        }
        
        UIView.animate(withDuration: 0.85, delay: 0, options: [UIViewAnimationOptions.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { success in
            self.launchScreenStackView.isHidden = true
            self.titleLabel.isHidden = false
        })
        
        UIView.animate(withDuration: 0.60, delay: 0.25, options: [], animations: {
            self.newWineView.alpha = 1
            self.myWinesView.alpha = 1
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func tappedNewWine() {
        showNavBar = true
        performSegue(withIdentifier: "addWine", sender: nil)
    }
    
    @objc func tappedMyWines() {
        showNavBar = true
        performSegue(withIdentifier: "myWines", sender: nil)
    }
}
