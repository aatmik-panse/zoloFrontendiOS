// Importing Foundation library
import Foundation

// A struct for holding book details
struct BookList: Identifiable {
    let id = UUID()
    let name: String
    let by: String
    let imageName: String
    var dueDate: Date?  // The date when the book is due to be returned
    var genre: [String] // The genres of the book
}
let numberOfDays: Int = 8
let date = Calendar.current.date(byAdding: .day, value: numberOfDays, to: Date())


// Importing Foundation and Combine libraries
import Foundation
import Combine

// A ViewModel for managing book details
class BookViewModel: ObservableObject {
    @Published var bookDetails: [BookList] = [
        BookList(name: "Elon", by: "Naman", imageName: "elon", dueDate: date, genre: ["New","Self"]),
        BookList(name: "Steve", by: "Ram", imageName: "fan", dueDate: date, genre: ["New","Self"]),
        BookList(name: "Tata", by: "Raman", imageName: "elon", dueDate: date, genre: ["New","Self"]),
        BookList(name: "Steve", by: "Ram", imageName: "fan", dueDate: date, genre: ["New","Self"]),
        BookList(name: "Tata", by: "Raman", imageName: "elon", dueDate: date, genre: ["New","Self"]),
        BookList(name: "Naman", by: "Bheem", imageName: "Good", dueDate: date, genre: ["New","Self"])
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
        let newGenres = ["Genre1", "Genre2"] // Replace with actual genres or get them from user input
        let newBook = BookList(name: bookName, by: author, imageName: imageName, dueDate: Date(), genre: newGenres)
        viewModel.bookDetails.append(newBook)

        // Clear the form fields
        bookName = ""
        author = ""
        imageName = ""
    }

}
struct AddNewBookView: View {
    @ObservedObject var viewModel: BookViewModel
    @State private var name = ""
    @State private var author = ""
    @State private var dueDate = Date()
    @State private var genre = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Book Name", text: $name)
                TextField("Author", text: $author)
                DatePicker("Available Until", selection: $dueDate, displayedComponents: .date)
                TextField("Genre (comma separated)", text: $genre)
                
                Button("Add Book") {
                    let genres = genre.components(separatedBy: ", ").filter { !$0.isEmpty }
                    let newBook = BookList(name: name, by: author, imageName: "default", dueDate: dueDate, genre: genres)
                    viewModel.bookDetails.append(newBook) // Append directly to the array

                    // Clearing the form fields can be done here if needed
                }

            }
            .navigationBarTitle("Add Book", displayMode: .inline)
        }
    }
}

// Preview provider for AddBook
struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
    }
}
