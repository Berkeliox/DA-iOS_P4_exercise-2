//
//  UserListRepository.swift
//  User
//
//  Created by Jean-Hugues on 24/03/2025.
//

import Foundation

// Ajout pour les tests
protocol UserListRepositoryProtocol {
    func fetchUsers(quantity: Int) async throws -> [User]
}

struct UserListRepository: UserListRepositoryProtocol {

    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)

    init(
        executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
    ) {
        self.executeDataRequest = executeDataRequest
    }

    func fetchUsers(quantity: Int) async throws -> [User] {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw URLError(.badURL)
        }

        let request = try URLRequest(
            url: url,
            method: .GET,
            parameters: [
                "results": quantity
            ]
        )

        let (data, _) = try await executeDataRequest(request)
        
        let response = try JSONDecoder().decode(UserListResponse.self, from: data)
        
        return response.results.map(User.init)
    }
}
