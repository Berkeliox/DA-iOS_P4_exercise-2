//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Jean-Hugues on 29/03/2025.
//

import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {

    // Exemple de test pour le ViewModel
    func testGivenAViewModel_WhenCallingInput_ThenOutputReturns() {
        
        // Given : on initialise le ViewModel
        let viewModel = UserListViewModel()

        // Quand on appelle la méthode de fetch
        let initialUsersCount = viewModel.users.count

        // When : on simule un input, ici on appelle une fonction pour charger les utilisateurs
        viewModel.fetchUsers()

        // Then : on vérifie le résultat attendu = le nombre d'utilisateurs a augmenté
        XCTAssertEqual(viewModel.users.count, initialUsersCount + 1, "Le tableau d'utilisateurs doit contenir un utilisateur de plus après fetch.")
    }
}
