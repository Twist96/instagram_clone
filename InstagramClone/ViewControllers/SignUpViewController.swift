
import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        decorateTextField(textField: usernameTextField)
        decorateTextField(textField: emailTextField)
        decorateTextField(textField: passwordTextField)
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
    }
    
}
