//
//  DataModule.swift
//  GitHubSearchApp
//
//  Created by Ivo Vasilski on 9.08.24.
//

import Foundation


// Define the equivalent of the MainRepository class in Swift
class MainRepository {
    let httpClient: OkHttpClient

    init(httpClient: OkHttpClient) {
        self.httpClient = httpClient
    }
}

// Define the OkHttpClient class or use an existing networking library in Swift
class OkHttpClient {
    init() {
        // Initialization code for OkHttpClient
    }
}

// Singleton dependency container
class DataModule {

    static let shared = DataModule()

    private init() { }

    // Provides a singleton instance of MainRepository
    func provideMainRepository() -> MainRepository {
        let httpClient = provideOkHttpClient()
        return MainRepository(httpClient: httpClient)
    }

    // Provides a singleton instance of OkHttpClient
    func provideOkHttpClient() -> OkHttpClient {
        return OkHttpClient()
    }
}

// Usage
let mainRepository = DataModule.shared.provideMainRepository()

