//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Jean-Hugues on 29/03/2025.
//

import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {

    // Teste si la récupération d'utilisateurs fonctionne correctement avec le FakeRepository
    func testFetchUsersSuccess() async {
        // Given : Initialisation d'un fake repository avec des utilisateurs factices
        let fakeRepository = FakeUserListRepository()
        fakeRepository.fakeUsers = [
            User(name: "John", dob: "1990", picture: "url1"),
            User(name: "Jane", dob: "1995", picture: "url2")
        ]
        
        // On initialise le ViewModel avec notre Fake Repository
        let viewModel = UserListViewModel(repository: fakeRepository)
        
        // When : On appelle la méthode pour récupérer les utilisateurs
        await viewModel.fetchUsers()
        
        // Then : On vérifie que les utilisateurs ont bien été ajoutés au ViewModel
        XCTAssertEqual(viewModel.users.count, 2, "Le nombre d'utilisateurs devrait être 2.")
        XCTAssertEqual(viewModel.users[0].name, "John", "Le premier utilisateur devrait être John.")
        XCTAssertEqual(viewModel.users[1].name, "Jane", "Le second utilisateur devrait être Jane.")
    }

    // Teste si une erreur est bien lancée dans le cas où le repository échoue
    func testFetchUsersFailure() async {
        // Given : Initialisation du fake repository avec un comportement d'échec
        let fakeRepository = FakeUserListRepository()
        fakeRepository.shouldFail = true
        
        // On initialise le ViewModel avec notre Fake Repository
        let viewModel = UserListViewModel(repository: fakeRepository)
        
        // When : On appelle la méthode pour récupérer les utilisateurs
        do {
            try await viewModel.fetchUsers()
            XCTFail("L'appel aurait dû échouer")
        } catch {
            // Then : On vérifie que l'erreur se produit
            XCTAssertTrue(error is NSError, "Une erreur devrait être lancée.")
        }
    }
}
