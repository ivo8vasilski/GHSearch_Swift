import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func configure(with user: User){
        lbl_name.text = user.login
        if let url = URL(string: user.avatarUrl){
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL){
        URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                self?.lbl_avatar.image = UIImage(data: data)
            }
            
        }.resume()
    }
    
}
