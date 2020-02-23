
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
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadPost() {
        activityIndicatorView.startAnimating()
        Api.post.observePosts { post in
            self.fetchAuthor(authorId: post.authorId!, onCompleted: {
                self.posts.append(post)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
        }

    }
    
    func fetchAuthor(authorId: String, onCompleted: @escaping () -> Void) {
       
        Api.user.observeUser(userId: authorId) { (user) in
            self.authors.append(user)
            onCompleted()
        }
    }
    
    @IBAction func logoutBtn_touchUpInside(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
        }catch{
            return
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        present(vc, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comment_segue"{
            let vc = segue.destination as! CommentViewController
            vc.postId = sender as? String
        }
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
        cell.homeVC = self
        return cell
    }
    
}
