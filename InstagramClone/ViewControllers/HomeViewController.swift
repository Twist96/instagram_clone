
import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var authors = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableView.automaticDimension
        
        loadPost()
    }
    
    func loadPost() {
        activityIndicatorView.startAnimating()
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPostPhoto(dict: dict)
                self.fetchAuthor(authorId: post.authorId!, onCompleted: {
                    self.posts.append(post)
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func fetchAuthor(authorId: String, onCompleted: @escaping () -> Void) {
        Database.database().reference().child("user").child(authorId).observe(.value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else{
                return
            }
            let user = User.transformUser(dict: dict)
            self.authors.append(user)
            onCompleted()
        }
    }
    

    @IBAction func logoutBtn_touchUpInside(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
        }catch{
            print("failed logout: \(error.localizedDescription)")
            return
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        present(vc, animated: true, completion: nil)
        
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post_cell") as! HomeTableViewCell
        cell.post = posts[indexPath.row]
        cell.author = authors[indexPath.row]
        return cell
    }
    
    
    
}
