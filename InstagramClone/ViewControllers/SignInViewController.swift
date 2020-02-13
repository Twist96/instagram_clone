//
//  ViewController.swift
//  InstagramClone
//
//  Created by Tochi on 12/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateTextField(textField: emailTextField)
        decorateTextField(textField: passwordTextField)
    }

    func decorateTextField(textField: UITextField) {
        textField.backgroundColor = UIColor.clear
        textField.tintColor = UIColor.white
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)])
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor(displayP3Red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLayer)
    }

}

