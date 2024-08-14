//
//  MainRepository.swift
//  GitHubSearchApp
//
//  Created by Ivo Vasilski on 9.08.24.
//

import Foundation



// Define the Data structure
struct Data: Decodable {
    // Add the relevant properties of Data here
}

// Define the GHResponse structure
struct GHResponse: Decodable {
    let items: [Data]
}

// Define the MainRepository class
class MainRepository {
    private let httpClient: URLSession
    private let token = "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"

    init(httpClient: URLSession = URLSession.shared) {
        self.httpClient = httpClient
    }

    func getData() -> [String] {
        return ["1", "2", "3"]
    }

    func getItems(query: String, page: Int, perPage: Int = 10) async throws -> [Data] {
        let url = URL(string: "https://api.github.com/search/users?q=\(query)&page=\(page)&per_page=\(perPage)")!

        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let (data, response) = try await httpClient.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let rawResponse = try decoder.decode(GHResponse.self, from: data)

        print(rawResponse)

        return raw

