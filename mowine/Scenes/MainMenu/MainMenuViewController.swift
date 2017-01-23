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

    override func viewDidLoad() {
        super.viewDidLoad()

        newWineImage.fixTintIssue()
        myWinesImage.fixTintIssue()
        
        newWineView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedNewWine)))
        myWinesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedMyWines)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        performSegue(withIdentifier: "newWine", sender: nil)
    }
    
    func tappedMyWines() {
        performSegue(withIdentifier: "myWines", sender: nil)
    }
}
