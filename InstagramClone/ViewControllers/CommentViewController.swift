
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let postId = ""
    //let comments: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        emptyCommentSection()
        handleTextField()
    }
    
    func loadCommet() {
        let postRefernce = Database.database().reference().child("post-comments").child(postId)
        postRefernce.observe(.childAdded) { (snapShot) in
            Database.database().reference().child("comments").child(snapShot.key).observe(.value, with: { (snapshotComment) in
                
            })
        }
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingDidBegin)
    }
    
    @objc func textFieldDidChange() {
        if let comment = commentTextField.text, !comment.isEmpty {
            sendButton.setTitleColor(.black, for: .normal)
            sendButton.isEnabled = true
            return
        }
        sendButton.setTitleColor(.lightGray, for: .normal)
        sendButton.isEnabled = false
    }
    
    

    @IBAction func sendBtn_touchUpInside(_ sender: Any) {
        
        let ref = Database.database().reference()
        let commentRefernce = ref.child("comments")
        let newCommentId = commentRefernce.childByAutoId().key
        let newCommentRefernce = commentRefernce.child(newCommentId!)
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        
        let userId = currentUser.uid
        newCommentRefernce.setValue(["authorid": userId, "commentText": self.commentTextField!]) { (error, dbReference) in
            
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            // add comment to post
            let postRefernce = Database.database().reference().child("post-comments").child(self.postId).child(newCommentId!)
            postRefernce.setValue(true, withCompletionBlock: { (error, dbRefence) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                self.emptyCommentSection()
            })
        }
    }
    
    func emptyCommentSection()  {
        commentTextField.text = ""
        sendButton.setTitleColor(.gray, for: .normal)
        sendButton.isEnabled = true
    }
    
    
    
}
