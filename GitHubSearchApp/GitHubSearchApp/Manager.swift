//
//  Manager.swift
//  GitHubSearchApp
//
//  Created by Ivo Vasilski on 9.08.24.
//

import Foundation

class UserManager {
    func fetchUsers(query: String, page: Int, completion: @escaping (Result<GHResponse, Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/search/users?q=\(query)&page=\(page)&per_page=10") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add the GitHub personal access token to the request header
        let token = "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"
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let jsonData = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodeData = try decoder.decode(GHResponse.self, from: jsonData)
                completion(.success(decodeData))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
