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
    @Published var isLoading = false // Pour voir si on charge des données
    @Published var isGridView = false // Si on voit une liste par exemple
    
    private let repository: UserListRepositoryProtocol

    init(repository: UserListRepositoryProtocol = UserListRepository()) {
        self.repository = repository
    }
    
    // Déplacé ici car c'est de la logique aussi
    @MainActor // Exécute en MainThread malgré le Task
    func fetchUsers() async {
        isLoading = true
        Task { // Autre manière d'appeler le thread en background | Obligé de le faire en BG puisque c'est un téléchargement mais du coup MainActor
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                self.users.append(contentsOf: users)
                isLoading = false
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    // Ça c'est une func qu'on avait dans View qu'on transforme en Output (sortie)
    var shouldLoadMoreData: Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && lastItem.id == users.last?.id
    }
    
    // Pour reload, on doit d'abord supprimer tous les users puis exécuter la fonction fetchUsers
    @MainActor
    func reloadUsers() async {
        users.removeAll()
        await fetchUsers()
    }
    
}

/* On appelle ici la fonction fetchUsers dans Repository pour obtenir les utilisateurs (pour pas que ce soit la Vue qu'il l'ai directement). En gros, c'est la méthode pour les récupérer.
 J'avais déjà mis la func dedans mais je la supprime pour ne pas avoir 2 func fetchUsers
 
func fetchUsers() {
    self.users = repository.fetchUsers()
}*/
