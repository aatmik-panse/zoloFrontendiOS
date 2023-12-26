// image adder not coded by me 

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
    @State private var genresText = ""


    var body: some View {
        // A navigation view wrapping the whole content
        NavigationView {
            Form {
                Section(header: Text("Add Book Details")) {
                    TextField("Book Name", text: $bookName)
                    TextField("Author", text: $author)
                    TextField("Genres (comma separated)", text: $genresText)
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

    //not working
    
    func addBook() {
        let genres = genresText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        // Ensuring that selectedImage is not nil
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            // Inform user about the error
            return
        }

        let uniqueImageName = UUID().uuidString + ".jpg"

        saveImage(imageData, withName: uniqueImageName) { success in
            guard success else {
                // Inform user that saving the image failed
                return
            }
            
            let newBook = BookList(name: bookName, by: author, imageName: uniqueImageName, dueDate: nil, genre: genres)
            viewModel.bookDetails.append(newBook)
            
            resetForm()
        }
    }

    private func saveImage(_ imageData: Data, withName name: String, completion: @escaping (Bool) -> Void) {
        guard let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name) else {
            completion(false)
            return
        }
        
        do {
            try imageData.write(to: imageURL)
            completion(true)
        } catch {
            print("Error saving image: \(error)")
            completion(false)
        }
    }

    private func resetForm() {
        bookName = ""
        author = ""
        genresText = ""
        
        presentationMode.wrappedValue.dismiss()
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
