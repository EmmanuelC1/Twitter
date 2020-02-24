//
//  LoginViewController.swift
//  Twitter
//
//  Created by Emmanuel Castillo on 2/16/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if user was already logged in, go straight to segue to home screen w/o Login in again
        if(UserDefaults.standard.bool(forKey: "userLoggedIn") == true) {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        //Authentication URL (Request Token)
        let authUrl = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: authUrl, success: {
            //Everytime user succesfully logs in, userLoggedIn is set to true to avoid user getting logout if app closes
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            //segue performed
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
        }, failure: { (Error) in
            //error message if user failed to login
            print("Error: Cannot login >> \(Error)")
        })
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
