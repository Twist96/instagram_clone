
import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commenTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var postId: String?
    var comments = [Comment]()
    var authors = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comment"
        commenTableView.dataSource = self
        commenTableView.estimatedRowHeight = 74
        commenTableView.rowHeight = UITableView.automaticDimension
        emptyCommentSection()
        handleTextField()
        loadCommet()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = keyboardFrame!.height * -1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadCommet() {
        
        Api.post_comments.observeComment(postId: postId!) { (commentId) in
            Api.comment.observeComment(commentId: commentId, onComplete: { (comment) in
                self.comments.append(comment)
                self.getAuthorsInfo(authorId: comment.authorId!)
            });
        }
    }
    
    func getAuthorsInfo(authorId: String) {
        Api.user.observeUser(userId: authorId) { (user) in
            self.authors.append(user)
            self.commenTableView.reloadData()
        }
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
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
        
        let commentRefernce = Api.comment.REF_COMMENTS
        let newCommentId = commentRefernce.childByAutoId().key
        let newCommentRefernce = commentRefernce.child(newCommentId!)
        guard let currentUser = Api.user.CURRENT_USER else{
            return
        }
        
        let userId = currentUser.uid
        newCommentRefernce.setValue(["authorId": userId, "commentText": self.commentTextField.text!]) { (error, dbReference) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            Api.post_comments.andCommentId(postId: self.postId!, commnetId: newCommentId!, onComplete: { (error) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                self.emptyCommentSection()
                self.view.endEditing(true)
            })
        }
    }
    
    func emptyCommentSection()  {
        commentTextField.text = ""
        sendButton.setTitleColor(.gray, for: .normal)
        sendButton.isEnabled = true
    }
    
}

extension CommentViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment_cell") as! CommentTableViewCell
        cell.author = authors[indexPath.row]
        cell.comment = comments[indexPath.row]
        return cell
    }
    
}
