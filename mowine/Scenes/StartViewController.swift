//
//  StartViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import AWSMobileClient
import SwiftyBeaver

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                SwiftyBeaver.debug("UserState: \(userState.rawValue)")
                SwiftyBeaver.debug("Current user id: \(Container.shared.session.currentUserId?.asString ?? "nil")")
                
                switch userState {
                case .signedIn:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    appDelegate.window?.rootViewController = destinationVC
                case .signedOut:
                    let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
                    let destinationVC = storyboard.instantiateInitialViewController()!
                    appDelegate.window?.rootViewController = destinationVC
                default:
                    break
                }
                
            } else if let error = error {
                SwiftyBeaver.debug("error: \(error.localizedDescription)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
