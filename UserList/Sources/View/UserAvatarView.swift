//
//  UserAvatarView.swift
//  UserList
//
//  Created by Jean-Hugues on 18/05/2025.
//

import SwiftUI

// Refacto
struct UserAvatarView: View {
    let url: String
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}
