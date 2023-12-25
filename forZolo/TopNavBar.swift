// Importing SwiftUI library
import SwiftUI

// A view for the top navigation bar
struct TopNavBar: View {
    @Binding var isAddBookPresented: Bool // Binding variable to manage AddBookView presentation

    var body: some View {
        HStack {
            Button {
                isAddBookPresented.toggle() // Toggling AddBookView presentation when button is tapped
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.primary) // Dynamic color that adapts to light and dark mode
                Text("Add Book")
                    .foregroundColor(.primary)
            }
            Spacer()
            Button {
                // Handle other button action
            } label: {
                Image(systemName: "house.fill")
                    .font(.title)
                    .foregroundColor(.primary) // Dynamic color that adapts to light and dark mode
            }
        }
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10) // Adding shadow to the HStack
    }
}

// Preview provider for TopNavBar
struct TopNavBar_Preview: PreviewProvider {
    static var previews: some View {
        TopNavBar(isAddBookPresented: .constant(false))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
