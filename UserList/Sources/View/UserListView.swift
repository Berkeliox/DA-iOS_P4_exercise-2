//
//  UserListView.swift
//  UserList
//
//  Created by Jean-Hugues on 24/03/2025.
//

import SwiftUI

struct UserListView: View {
    
    let repository: UserListRepositoryProtocol = UserListRepository()
    @StateObject var viewModel: UserListViewModel // On observe ce qu'il se passe dans ce fichier ViewModel
    
    var body: some View {
        
        NavigationView {
            Group {
                if viewModel.isGridView {
                    gridView()
                } else {
                    listView()
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(selection: $viewModel.isGridView, label: Text("Display")) {
                        Image(systemName: "rectangle.grid.1x2.fill")
                            .tag(true)
                            .accessibilityLabel(Text("Grid view"))
                        Image(systemName: "list.bullet")
                            .tag(false)
                            .accessibilityLabel(Text("List view"))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.reloadUsers()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchUsers()
            }
        }
    }

    @ViewBuilder
    private func listView() -> some View {
        List(viewModel.users) { user in
            NavigationLink(destination: UserDetailView(user: user)) {
                HStack {
                    UserAvatarView(url: user.picture.medium, size: 50)

                    VStack(alignment: .leading) {
                        Text("\(user.name.first) \(user.name.last)")
                            .font(.headline)
                        Text("\(user.dob.date)")
                            .font(.subheadline)
                    }
                }
            }
            .onAppear {
                Task {
                    if viewModel.shouldLoadMoreData(currentItem: user) {
                        await viewModel.fetchUsers()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func gridView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        VStack {
                            UserAvatarView(url: user.picture.medium, size: 150)
                            Text("\(user.name.first) \(user.name.last)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .onAppear {
                        Task {
                            if viewModel.shouldLoadMoreData(currentItem: user) {
                                await viewModel.fetchUsers()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: UserListViewModel(repository: UserListRepository()))
    }
}
