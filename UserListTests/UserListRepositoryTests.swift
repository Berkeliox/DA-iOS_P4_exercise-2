//
//  UserListRepositoryTests 2.swift
//  UserList
//
//  Created by Jean-Hugues on 18/05/2025.
//


import XCTest
@testable import UserList

final class UserListRepositoryTests: XCTestCase {
    
    var viewModel: UserListViewModel!
    var mockData: MockData = MockData()
    var repository: UserListRepository!
    
    override func setUp() {
        super.setUp()
        self.mockData.validResponse = true
        self.repository = UserListRepository(executeDataRequest: mockData.executeRequest)
        self.viewModel = UserListViewModel(repository: self.repository)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        repository = nil
    }
    
   // Happy path test case
    func testFetchUsersSuccess() async throws {
        // Given
        let quantity = 2
        
        // When
        let users = try await self.repository.fetchUsers(quantity: quantity)

        // Then
        XCTAssertEqual(users.count, quantity)
        XCTAssertEqual(users[0].name.first, "John")
        XCTAssertEqual(users[0].name.last, "Doe")
        XCTAssertEqual(users[0].dob.age, 31)
        XCTAssertEqual(users[0].picture.large, "https://example.com/large.jpg")
        
        XCTAssertEqual(users[1].name.first, "Jane")
        XCTAssertEqual(users[1].name.last, "Smith")
        XCTAssertEqual(users[1].dob.age, 26)
        XCTAssertEqual(users[1].picture.medium, "https://example.com/medium.jpg")
    }
    
    func testFetchUsers_shouldHandleRepositoryError() async {
        // GIVEN
        mockData.validResponse = false // simule une mauvaise réponse

        // WHEN
        await self.viewModel.fetchUsers()

        // THEN
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    
//
//    // Unhappy path test case: Invalid JSON response
//    func testFetchUsersInvalidJSONResponse() async throws {
//        // Given
//        let invalidJSONData = "invalid JSON".data(using: .utf8)!
//        let invalidJSONResponse = HTTPURLResponse(
//            url: URL(string: "https://example.com")!,
//            statusCode: 200,
//            httpVersion: nil,
//            headerFields: nil
//        )!
//
//        let mockExecuteDataRequest: (URLRequest) async throws -> (Data, URLResponse) = { _ in
//            return (invalidJSONData, invalidJSONResponse)
//        }
//        
//        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
//        
//        // When
//        do {
//            _ = try await repository.fetchUsers(quantity: 2)
//            XCTFail("Response should fail")
//        } catch {
//            // Then
//            XCTAssertTrue(error is DecodingError)
//        }
//    }
}