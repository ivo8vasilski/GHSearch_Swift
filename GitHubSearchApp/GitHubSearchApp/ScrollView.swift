//
//  ScrollView.swift
//  GitHubSearchApp
//
//  Created by Ivo Vasilski on 13.08.24.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height * 2 {
            loadUsers()
        }
    }
}
