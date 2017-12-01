//
//  SignInViewController.swift
//  Final
//
//  Created by PJ Shalhoub on 11/24/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }



}
