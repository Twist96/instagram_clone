
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
    }
    
    @IBAction func signUpBtn_tapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            let uid = result!.user.uid

            let storageRef = Storage.storage().reference().child("users_profile").child(uid)
            if let img = self.selectedImage, let data = img.jpegData(compressionQuality: 0.1){
                storageRef.putData(data, metadata: nil, completion: { (metaData, error) in
                    if error != nil{
                        print("error saving image \( error!.localizedDescription)")
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil{
                            print("error get image url \(error!.localizedDescription)")
                            return
                        }
                        let ref = Database.database().reference()
                        let userReference = ref.child("user")
                        let newUserRefernce = userReference.child(uid)
                        newUserRefernce.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!, "profileImageUrl": url!.absoluteString])
                    })
                })
            }else{
                print("failed to pick image")
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
