
import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        loadUsers()
    }
    
    func loadUsers(){
        Api.user.observeUsers { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }

}

extension DiscoverViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCell") as! DiscoverTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    
}
