//
//  UserListViewModelTests.swift
//  UserList
//
//  Created by Jean-Hugues on 18/05/2025.
//


import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {
    var viewModel: UserListViewModel!
    var mockData: MockData = MockData()
    var repository: UserListRepository!

    override func setUp() {
        super.setUp()
        mockData.validResponse = true
        repository = UserListRepository(executeDataRequest: mockData.executeRequest)
        viewModel = UserListViewModel(repository: repository)
    }

    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }

    func testShouldLoardMoreData() async {
        //Given
        await viewModel.fetchUsers()

        let currentUser = viewModel.users.last!

        //When
        let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentUser)

        //Then
        XCTAssertTrue(shouldLoadMoreData)
    }

    func testShouldNotLoardMoreData() async {
        //Given
        await viewModel.fetchUsers()

        let currentUser = viewModel.users.first!

        //When
        let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentUser)

        //Then
        XCTAssertFalse(shouldLoadMoreData)
    }

    func testReloadUsersSuccess() async {
        //Given
        await viewModel.fetchUsers()

        let initialUsers = viewModel.users
        //When
        await viewModel.reloadUsers()

        //Then
        for user in viewModel.users {
            XCTAssertFalse(initialUsers.contains(where: { $0.id == user.id }))
        }


    }

//    // Teste si la récupération d'utilisateurs fonctionne correctement avec le FakeRepository
//    func testFetchUsersSuccess() async {
//        // Given : Initialisation d'un fake repository avec des utilisateurs factices
//        let fakeRepository = FakeUserListRepository()
//        fakeRepository.fakeUsers = [
//            User(user: UserListResponse.User(
//                name: .init(title: "Mr", first: "John", last: "Doe"),
//                dob: .init(date: "1990-01-01", age: 31),
//                picture: .init(large: "url1", medium: "", thumbnail: "")
//            )),
//            User(user: UserListResponse.User(
//                name: .init(title: "Ms", first: "Jane", last: "Smith"),
//                dob: .init(date: "1995-02-15", age: 26),
//                picture: .init(large: "url2", medium: "", thumbnail: "")
//            ))
//        ]
//        
//        // On initialise le ViewModel avec notre Fake Repository
//        let viewModel = UserListViewModel(repository: fakeRepository)
//        
//        // When : On appelle la méthode pour récupérer les utilisateurs
//        await viewModel.fetchUsers()
//        
//        // Then : On vérifie que les utilisateurs ont bien été ajoutés au ViewModel
//        let user = viewModel.users[0]
//        XCTAssertEqual(user.name.first, "John")
//        XCTAssertEqual(user.name.last, "Doe")
//        XCTAssertEqual(user.dob.date, "1990-01-01")
//        XCTAssertEqual(user.dob.age, 31)
//        XCTAssertEqual(user.picture.large, "url1") // ou .thumbnail ou .medium selon le cas
//
//    }
//
//    // Teste si une erreur est bien lancée dans le cas où le repository échoue
//    func testFetchUsersFailure() async {
//        // Given : Initialisation du fake repository avec un comportement d'échec
//        let fakeRepository = FakeUserListRepository()
//        fakeRepository.shouldFail = true
//        
//        // On initialise le ViewModel avec notre Fake Repository
//        let viewModel = UserListViewModel(repository: fakeRepository)
//        
//        // When : On appelle la méthode pour récupérer les utilisateurs
//        do {
//            await viewModel.fetchUsers()
//            XCTAssertEqual(viewModel.errorMessage, "Une erreur est survenue lors du chargement.")
//        }
//    }
//    
//    func testReloadUsers_ShouldClearUsersAndFetchAgain() async {
//        let fakeRepository = FakeUserListRepository()
//        fakeRepository.fakeUsers = [
//            makeFakeUser(first: "Alice"),
//            makeFakeUser(first: "Bob")
//        ]
//
//        let viewModel = UserListViewModel(repository: fakeRepository)
//
//        await viewModel.fetchUsers()
//        XCTAssertEqual(viewModel.users.count, 2)
//
//        // Change les données pour simuler un "rechargement"
//        fakeRepository.fakeUsers = [
//            makeFakeUser(first: "Charlie")
//        ]
//
//        await viewModel.reloadUsers()
//
//        XCTAssertEqual(viewModel.users.count, 1)
//        XCTAssertEqual(viewModel.users[0].name.first, "Charlie")
//    }
//
//    private func makeFakeUser(first: String) -> User {
//        User(user: UserListResponse.User(
//            name: .init(title: "Mr", first: first, last: "Test"),
//            dob: .init(date: "1990-01-01", age: 30),
//            picture: .init(large: "url", medium: "url", thumbnail: "url")
//        ))
//    }
//
//    func testShouldLoadMoreData_WhenOnLastItemAndNotLoading_ShouldReturnTrue() {
//        let user = makeFakeUser(first: "Foo")
//        let viewModel = UserListViewModel(repository: FakeUserListRepository())
//        viewModel.users = [user]
//        viewModel.isLoading = false
//
//        let result = viewModel.shouldLoadMoreData(currentItem: user)
//        XCTAssertTrue(result)
//    }
//
//    func testShouldLoadMoreData_WhenNotOnLastItem_ShouldReturnFalse() {
//        let first = makeFakeUser(first: "A")
//        let second = makeFakeUser(first: "B")
//        let viewModel = UserListViewModel(repository: FakeUserListRepository())
//        viewModel.users = [first, second]
//        viewModel.isLoading = false
//
//        let result = viewModel.shouldLoadMoreData(currentItem: first)
//        XCTAssertFalse(result)
//    }
//
//    func testShouldLoadMoreData_WhenLoading_ShouldReturnFalse() {
//        let user = makeFakeUser(first: "C")
//        let viewModel = UserListViewModel(repository: FakeUserListRepository())
//        viewModel.users = [user]
//        viewModel.isLoading = true
//
//        let result = viewModel.shouldLoadMoreData(currentItem: user)
//        XCTAssertFalse(result)
//    }



    
}