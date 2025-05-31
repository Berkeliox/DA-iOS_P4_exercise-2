//
//  UserListViewModel.swift
//  UserList
//
//  Created by Jean-Hugues on 24/03/2025.
//

import Foundation

class UserListViewModel: ObservableObject {
    
    // Quand on change ici, UserListView observe cet objet et capte les changements
    @Published var users: [User] = [] // Les utilisateurs à afficher
    @Published var isLoading: Bool = false // Pour voir si on charge des données
    @Published var isGridView: Bool = false // Si on voit une liste par exemple
    @Published var errorMessage: String? // Pour le test des

    // Pas de valeur par défaut mais on la déclare grâce à l'init
    private let repository: UserListRepositoryProtocol

    // Besoin de ça pour qu'il puisse changer de repository, et ne pas dépendre que de l'API parce que pour les tests c'est pas bien
    init(repository: UserListRepositoryProtocol) {
        self.repository = repository
    }
    
    @MainActor
    func fetchUsers() async {
        isLoading = true
        do {
            let fetchedUsers = try await repository.fetchUsers(quantity: 10)
            self.users.append(contentsOf: fetchedUsers)
            self.isLoading = false
            self.errorMessage = nil // on efface l'erreur s'il y a du succès
        } catch {
            self.isLoading = false
            self.errorMessage = "Une erreur est survenue lors du chargement."
        }
    }

    // Ça c'est une func qu'on avait dans View qu'on transforme en Output (sortie)
    func shouldLoadMoreData(currentItem: User) -> Bool {
        guard let last = users.last else { return false }
        return !isLoading && currentItem.id == last.id
    }

    // Pour reload, on doit d'abord supprimer tous les users puis exécuter la fonction fetchUsers
    @MainActor
    func reloadUsers() async {
        users.removeAll()
        await fetchUsers()
    }
}
