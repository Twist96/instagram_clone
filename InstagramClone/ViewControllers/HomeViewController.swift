
import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
