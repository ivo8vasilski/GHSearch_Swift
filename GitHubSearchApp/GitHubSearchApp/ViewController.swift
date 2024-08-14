import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var table_Data: UITableView!
    
    var myUsers: [User] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                table_Data.reloadData()
            }
        }
    }
    
    var currentPage = 1
    var isLoading = false
    var query: String?
    
    let userManager = UserManager()

    @IBAction func searchBtn(_ sender: UIButton) {
        guard let searchText = searchField.text, !searchText.isEmpty else {
            print("Search field is empty.")
            return
        }
        
        query = searchText
        currentPage = 1
        myUsers.removeAll()
        loadUsers()
    }
    
    func loadUsers() {
        
        guard let query = query, !isLoading else { return }
        isLoading = true
        
        userManager.fetchUsers(query: query, page: currentPage) { result in
            self.isLoading = false
            switch result {
            case .success(let response):
                self.myUsers.append(contentsOf: response.items)
                DispatchQueue.main.async {
                    self.table_Data.reloadData()
                }
            case .failure(let error):
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    func loadMoreUsers() {
        
        guard let query = query, !isLoading else { return }
        currentPage += 1
        loadUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table_Data.dataSource = self
        table_Data.delegate = self
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height * 2 {
            loadMoreUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let user = myUsers[indexPath.row]
        cell.configure(with: user)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewConnection",
           let destination = segue.destination as? SecondViewController,
           let indexPath = table_Data.indexPathForSelectedRow {
            let selectedUser = myUsers[indexPath.row]
            destination.user = selectedUser
        }
    }
}

