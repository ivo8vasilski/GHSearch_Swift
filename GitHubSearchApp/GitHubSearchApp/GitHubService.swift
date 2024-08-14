//
//  GitHubService.swift
//  GitHubSearchApp
//
//  Created by Ivo Vasilski on 9.08.24.
//

import Foundation

import Foundation

class GitHubService {
    
    static let shared = GitHubService()
    
    private init() {}
    
    func fetchUsers(query: String, completion: @escaping (Result<[User], Error>) -> Void) {
        let urlString = "https://api.github.com/search/users?q=\(query)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GHResponse.self, from: data)
                completion(.success(decodedResponse.items))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        
        task.resume()
    }
}
