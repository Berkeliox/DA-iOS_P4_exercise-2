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
 
}
