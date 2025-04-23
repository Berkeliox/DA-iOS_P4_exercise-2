//
//  FakeUserListRepository.swift
//  UserListTests
//
//  Created by Jean-Hugues on 23/04/2025.
//

import Foundation
@testable import UserList

// Un fake repository pour les tests
class FakeUserListRepository: UserListRepository {
    var shouldFail = false
    var fakeUsers: [User] = []  // Liste d'utilisateurs factices

    func fetchUsers(quantity: Int) async throws -> [User] {
        if shouldFail {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)  // On simule une erreur
        } else {
            return fakeUsers  // Retourne les utilisateurs factices
        }
    }
}

