//
//  MainMenuViewController.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet weak var newWineImage: UIImageView!
    @IBOutlet weak var myWinesImage: UIImageView!
    @IBOutlet weak var newWineView: UIView!
    @IBOutlet weak var myWinesView: UIView!

    private var showNavBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        newWineImage.fixTintIssue()
        myWinesImage.fixTintIssue()
        
        newWineView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedNewWine)))
        myWinesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedMyWines)))
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if showNavBar {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tappedNewWine() {
        showNavBar = false
        performSegue(withIdentifier: "newWine", sender: nil)
    }
    
    func tappedMyWines() {
        showNavBar = true
        performSegue(withIdentifier: "myWines", sender: nil)
    }
}
