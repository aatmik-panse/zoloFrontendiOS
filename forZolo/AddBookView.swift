// Importing SwiftUI library
import SwiftUI

// A view for adding new books
struct AddBookView: View {
    
    @State private var selectedImage: UIImage? // State variable for selected image
    @Environment(\.presentationMode) var presentationMode // Environment variable to manage the presentation mode
    @ObservedObject var viewModel: BookViewModel // ViewModel for managing book data
    @State private var isImagePickerPresented = false // Add this line

    // State variables to hold form field values
    @State private var bookName = ""
    @State private var author = ""
    @State private var imageName = ""

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
                
                Section {
                    if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                           // ... existing code ...

                           Button("Select Image") {
                               isImagePickerPresented = true
                           }
                           .sheet(isPresented: $isImagePickerPresented) {
                               ImagePicker(selectedImage: $selectedImage) // Use non-optional binding
                           }
                       }
                
            }
            .navigationBarTitle("Add New Book") // Setting the navigation bar title
            .navigationBarItems(trailing:
                Button("Done") {
                    presentationMode.wrappedValue.dismiss() // Dismissing the form when Done is tapped
                }
            )
        }
    }

    // Function to add a new book
    // Function to add a new book
    func addBook() {
        // Ensure that selectedImage is not nil
        guard let selectedImage = selectedImage else {
            // Handle the case where no image is selected
            return
        }

        // Convert the selectedImage to Data
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            // Handle the case where image data cannot be created
            return
        }

        // Generate a unique filename for the image
        var imageName = UUID().uuidString + ".jpg"

        // Save the image to the app's documents directory
        if let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName) {
            do {
                try imageData.write(to: imageURL)

                // Create a new BookList with the image filename
                let newBook = BookList(name: bookName, by: author, imageName: imageName)
                
                // Add the new book to the viewModel
                viewModel.bookDetails.append(newBook)

                // Clear the form fields
                bookName = ""
                author = ""
                imageName = ""

                // Dismiss the form sheet
                presentationMode.wrappedValue.dismiss()
            } catch {
                // Handle the error if image cannot be saved
                print("Error saving image: \(error)")
            }
        }
    }

}
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage? // Use optional binding
    @Environment(\.presentationMode) private var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
