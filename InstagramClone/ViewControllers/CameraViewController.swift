
import UIKit

class CameraViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var removeBtn: UIBarButtonItem!
    
    var selectedPhoto: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        verifyPostStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.pickImage))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func verifyPostStatus() {
        if selectedPhoto != nil{
            shareBtn.isEnabled = true
            removeBtn.isEnabled = true
            shareBtn.backgroundColor = .black
        }else{
            shareBtn.isEnabled = false
            removeBtn.isEnabled = false
            shareBtn.backgroundColor = .lightGray
        }
    }
    
    @objc func pickImage(){
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.delegate = self
        present(imgPickerVC, animated: true, completion: nil)
    }
    
    @IBAction func removeBtn_touchUpInside(_ sender: Any) {
        clearViews()
    }
    
    @IBAction func shareBtn_touchUpInside(_ sender: Any) {
        if let img = selectedPhoto, let imageData = img.jpegData(compressionQuality: 0.3){
            ProgressHUD.show("Uploading post")
            HelperClass.UploadPost(imageData: imageData, caption: captionTextView.text!) { (error) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess()
                self.clearViews()
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    func clearViews() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "Placeholder-image")
        self.selectedPhoto = nil
        removeBtn.isEnabled = false
        verifyPostStatus()
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        photo.image = image
        selectedPhoto = image
        dismiss(animated: true, completion: nil)
    }
}
