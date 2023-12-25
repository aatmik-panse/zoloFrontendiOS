// Importing Foundation library
import Foundation

// A struct for holding book details
struct BookList: Identifiable{
    var id: UUID = UUID() // Unique identifier for each book
    var name:String // Name of the book
    var by:String // Author of the book
    var imageName:String // Image name for the book cover
    var lastDate:String="31/12/2023" // Last date for borrowing the book
}

// Importing Foundation and Combine libraries
import Foundation
import Combine

// A ViewModel for managing book details
class BookViewModel: ObservableObject {
    @Published var bookDetails: [BookList] = [
        BookList(name: "Elon", by: "Naman", imageName: "elon"),
        BookList(name: "Steve", by: "Ram", imageName: "fan"),
        BookList(name: "Tata", by: "Raman", imageName: "elon"),
        BookList(name: "Steve", by: "Ram", imageName: "fan"),
        BookList(name: "Tata", by: "Raman", imageName: "elon")
    ]
}
// Importing SwiftUI library
import SwiftUI

// A view for adding new books
struct AddBook: View {
    // State variables to hold form field values
    @State private var bookName = ""
    @State private var author = ""
    @State private var imageName = ""

    @ObservedObject var viewModel = BookViewModel() // ViewModel for managing book data

    var body: some View {
        // A navigation view wrapping the whole content
        NavigationView {
            Form {
                Section(header: Text("Add Book Details")) {
                    TextField("Book Name", text: $bookName)
                    TextField("Author", text: $author)
                    TextField("Image Name", text: $imageName)
                }

                Section {
                    Button(action: {
                        addBook()
                    }) {
                        Text("Add Book")
                    }
                }

                Section(header: Text("Book List")) {
                    ForEach(viewModel.bookDetails) { book in
                        VStack(alignment: .leading) {
                            Text("Name: \(book.name)")
                            Text("Author: \(book.by)")
                            Text("Image Name: \(book.imageName)")
                        }
                    }
                }
            }
            .navigationBarTitle("Book Library") // Setting the navigation bar title
        }
    }

    // Function to add a new book
    func addBook() {
        let newBook = BookList(name: bookName, by: author, imageName: imageName)
        viewModel.bookDetails.append(newBook)

        // Clear the form fields
        bookName = ""
        author = ""
        imageName = ""
    }
}

// Preview provider for AddBook
struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
    }
}
