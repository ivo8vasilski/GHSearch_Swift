//
//  SecondViewController.swift
//  GitHubSearchApp
//
//  Created by Ivo Vasilski on 8.08.24.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var lbl_login: UILabel!
   
    var user: User?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the login label
        lbl_login.text = user?.login
        
        // Set the avatar image
        if let avatarUrlString = user?.avatarUrl, let url = URL(string: avatarUrlString) {
            downloadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.img_View.image = image
                }
            }
        }
    }
    
    // Function to download the image
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
}

