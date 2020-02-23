
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

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
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil) { (metaData, error) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    self.saveDataToDatabase(photoUrl: url!.description)
                })
            }
        }
    }
    
    func saveDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postRef = ref.child("posts")
        let newPostId = postRef.childByAutoId().key!
        let newPostReference = postRef.child(newPostId)
        guard let uid = Auth.auth().currentUser?.uid  else {
            return
        }
        newPostReference.setValue(["authorId": uid, "photoUrl": photoUrl, "caption": captionTextView.text!]) { (error, dbRef) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            let myPostRef = Api.MyPosts.REF_MY_POST.child(uid).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, dbRef) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            })
            ProgressHUD.showSuccess()
            self.clearViews()
            self.tabBarController?.selectedIndex = 0
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
