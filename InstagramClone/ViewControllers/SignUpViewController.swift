
import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectedProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        decorateTextField(textField: usernameTextField)
        decorateTextField(textField: emailTextField)
        decorateTextField(textField: passwordTextField)
        signUpBtn.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectedProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.isEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        if let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            signUpBtn.setTitleColor(UIColor.white, for: .normal)
            signUpBtn.isEnabled = true
            return
        }
        
        signUpBtn.setTitleColor(UIColor.gray, for: .normal)
        signUpBtn.isEnabled = false
    }
    
    @IBAction func signUpBtn_tapped(_ sender: Any) {
        ProgressHUD.show("Signing Up. . .", interaction: false)
        view.endEditing(true)
        if let image = selectedImage{
            AuthService.SignUp(profileImage: image, username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess("Success")
                self.performSegue(withIdentifier: "signUpToTabbarVc", sender: self)
            }
        }
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           profileImage.image = img
            selectedImage = img
        }
        dismiss(animated: true, completion: nil)
    }
}
