// Refacto de AsyncImage
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
