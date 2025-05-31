//
//  MockData.swift
//  UserList
//
//  Created by Jean-Hugues on 18/05/2025.
//


import Foundation

@testable import UserList // Importer le projet

class MockData {
    
    let userMock1: UserListResponse.User
    let userMock2: UserListResponse.User
    let userListResponseMock: UserListResponse
    var validResponse: Bool = true
    
    init() {
        self.userMock1 = UserListResponse.User(name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"), dob: UserListResponse.User.Dob(date: "1990-01-01", age: 31), picture: UserListResponse.User.Picture(large: "https://example.com/large.jpg", medium: "https://example.com/medium.jpg", thumbnail: "https://example.com/thumbnail.jpg"))
        self.userMock2 = UserListResponse.User(name: UserListResponse.User.Name(title: "Ms", first: "Jane", last: "Smith"), dob: UserListResponse.User.Dob(date: "1995-02-15", age: 26), picture: UserListResponse.User.Picture(large: "https://example.com/large.jpg", medium: "https://example.com/medium.jpg", thumbnail: "https://example.com/thumbnail.jpg"))
        self.userListResponseMock = UserListResponse(results: [userMock1, userMock2])
    }
    
    // MARK: - Methods
        
        private func encodeData(userListResponseTypeMock : UserListResponse) throws -> Data { //encode en Data : binaire
            return try JSONEncoder().encode(userListResponseTypeMock)
        }
        
        func executeRequest(request: URLRequest) async throws -> (Data, URLResponse) { //mock de executeDataRequest
            if validResponse {
                return try await validMockResponse(request: request)
            } else {
                return try await invalidMockResponse(request: request)
            }
        }
        
        private func validMockResponse(request: URLRequest) async throws -> (Data, URLResponse) {
            let data = try encodeData(userListResponseTypeMock : userListResponseMock)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (data, response)
        }
        
        // réponse JSON ne correspond pas au format attendu
        private func invalidMockResponse(request: URLRequest) async throws -> (Data, URLResponse) {
            let invalidData = "invalidJSON".data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (invalidData, response)
        }
}
