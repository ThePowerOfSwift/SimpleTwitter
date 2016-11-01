//
//  ViewController.swift
//  SimpleTwitter
//
//  Created by Jonathan Cheng on 10/28/16.
//  Copyright © 2016 Jonathan Cheng. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let kLoginMainStoryboardName = "Main"
let kLoginRootViewControllerName = "LoginNavigationController"

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func getRootVCAfterLogin() -> UIViewController {
        // Completion code upon successful login
        let storyboard = UIStoryboard.init(name: kLoginMainStoryboardName, bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: kLoginRootViewControllerName)
        return rootVC
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        // Login to Twitter
        // Start OAuth session manager & initiate token request
        TwitterSessionManager.sharedInstance.login(completion: {            
            self.present(LoginViewController.getRootVCAfterLogin(), animated: true, completion: {
                // Completion code
            })
        
        }) { (error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
        }
    }
}

