
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    var user: User?
    var posts: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        fetchUserProfile()
        fetchUserPosts()
    }
    
    func fetchUserProfile() {
        Api.user.observeCurrentUser { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.profileCollectionView.reloadData()
        }
    }
    
    func fetchUserPosts() {
        guard let currentUser = Api.user.CURRENT_USER  else {
            return
        }
        Api.MyPosts.REF_MY_POST.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            Api.post.observePost(withId: snapshot.key, onCompletion: { (post) in
                self.posts.append(post)
                self.profileCollectionView.reloadData()
            })
        }
        
    }

}

extension ProfileViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = user{
            cell.user = user
        }
        return cell
    }

}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt section: IndexPath) -> CGSize {
        return CGSize(width: profileCollectionView.frame.width / 3 - 1, height: profileCollectionView.frame.width / 3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
