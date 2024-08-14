//
//  User + GHResponse.swift
//  GitHubSearchApp
//
//  Created by Ivo Vasilski on 9.08.24.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: String
    
    // Mapping the JSON key "avatar_url" to "avatarUrl"
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }
}

struct GHResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]
    
    // Mapping the JSON key "total_count" to "totalCount"
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case  incompleteResults = "incomplete_results"
        case items
    }
}

