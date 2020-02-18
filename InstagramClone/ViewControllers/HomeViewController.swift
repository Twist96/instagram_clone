
import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableView.automaticDimension
        
        loadPost()
    }
    
    func loadPost() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPostPhoto(dict: dict)
                self.posts.append(post)
                print(self.posts)
                self.tableView.reloadData()
            }
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
        return cell
    }
    
    
    
}
