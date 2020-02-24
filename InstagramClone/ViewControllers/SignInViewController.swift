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
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateTextField(textField: emailTextField)
        decorateTextField(textField: passwordTextField)
        signInBtn.isEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
        if Api.user.CURRENT_USER != nil{
            self.performSegue(withIdentifier: "signInToTabbarVc", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        handleTextField(textField: textField)
    }
    
    func handleTextField(textField: UITextField) {
        textField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            signInBtn.setTitleColor(UIColor.white, for: .normal)
            signInBtn.isEnabled = true
            return
        }
        signInBtn.setTitleColor(UIColor.gray, for: .normal)
        signInBtn.isEnabled = false
    }

    @IBAction func signinBtn_tapped(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting", interaction: false)
        AuthService.SignIn(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signInToTabbarVc", sender: self)
        }
    }
}

