import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var table_Data: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var myUsers: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.table_Data.reloadData()
            }
        }
    }
    
    var currentPage = 1
    var isLoading = false
    var query: String?
    
    let userManager = UserManager()
    let loadingSpinner = UIActivityIndicatorView(style: .medium)
    
    @IBAction func searchBtn(_ sender: UIButton) {
        guard let searchText = searchField.text, !searchText.isEmpty else {
            print("Search field is empty.")
            return
        }
        
        // Reset state for a new search
        query = searchText
        currentPage = 1
        myUsers.removeAll()
        table_Data.reloadData()
        
        // Start loading users for the new search
       
        loadUsers()
    }
    
    func loadUsers() {
        guard let query = query, !isLoading else { return }
        isLoading = true
       
        table_Data.tableFooterView = loadingSpinner
        loadingSpinner.startAnimating()
        
        userManager.fetchUsers(query: query, page: currentPage) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                self.loadingSpinner.stopAnimating()
                self.table_Data.tableFooterView = nil
                
            }
            
            switch result {
            case .success(let response):
                if response.items.isEmpty && self.myUsers.isEmpty {
                    self.showNoResultsMessage()
                } else {
                    self.myUsers.append(contentsOf: response.items)
                    self.hideNoResultsMessage()
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
        table_Data.tableFooterView = UIView() // Removes empty cells
        
        loadingSpinner.hidesWhenStopped = true
    }
    
    func showNoResultsMessage() {
        let noResultsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: table_Data.bounds.size.width, height: table_Data.bounds.size.height))
        noResultsLabel.text = "No results found"
        noResultsLabel.textAlignment = .center
        noResultsLabel.sizeToFit()
        
        table_Data.backgroundView = noResultsLabel
        table_Data.separatorStyle = .none
    }
    
    func hideNoResultsMessage() {
        table_Data.backgroundView = nil
        table_Data.separatorStyle = .singleLine
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Load more users when scrolling near the end
        if indexPath.row == myUsers.count - 1 && !isLoading {
            loadMoreUsers()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myUsers.isEmpty {
            return 0
        } else {
            hideNoResultsMessage()
            return myUsers.count
        }
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
