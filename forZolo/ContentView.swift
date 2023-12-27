// Importing SwiftUI library
import SwiftUI

struct ContentView: View {
    // State variables to manage date picker visibility and selected dates
    @State private var isDatePickerVisible = false
    @State private var selectedDates = Set<DateComponents>()
    @ObservedObject var viewModel = BookViewModel() // ViewModel for managing book data

    // The body of the ContentView
    var body: some View {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()

        // A navigation view wrapping the whole content
        NavigationView {
            // A ZStack for layering views on top of each other
            
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()

                // A VStack for vertical alignment of views
                VStack(alignment: .leading, spacing: 20.0) {
                    // Displaying an image with rounded corners and padding
                    Image("elon")
                        .resizable()
                        .cornerRadius(15.0)
                        .padding()

                    // A HStack for horizontal alignment of views
                    HStack {
                        // Displaying book title with large font and bold weight
                        Text("Elon Musk")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        // Creating space between title and rating section
                        Spacer()

                        // A VStack for vertical alignment of rating and review count
                        VStack {
                            // Displaying rating using star images
                            HStack {
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.leadinghalf.filled")
                            }.foregroundColor(.orange)
                            .font(.caption)
                            Text("Reviews 123")
                                .foregroundColor(.primary)
                        }
                    }.foregroundColor(.primary)

                    // Displaying author and poster details with relevant formatting
                    Text("Author :").font(.headline).padding(.bottom, -15.0)
                    Text("ASGLEE VANCE").font(.title2).foregroundColor(.primary)
                    Text("Posted By :").font(.headline).padding(.bottom, -15.0)
                    Text("VANCE").font(.title2).foregroundColor(.primary)

                    // A navigation link to DatePickerView
                    NavigationLink(destination: DatePickerView(selectedDates: $selectedDates)) {
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "book.circle.fill")
                            Text("Borrow This Book")
                            Spacer()
                        }
                        .font(.title) // Setting font size for the borrow button text
                        .foregroundColor(.primary)
                    }
                    .padding() // Adding padding around the borrow button
                    .background(Rectangle().foregroundColor(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0).shadow(radius: 20))
                    
                    
                    ForEach(viewModel.bookDetails.prefix(1)) { item in
                        if let dueDate = item.dueDate {
                            Text("Available for borrowing till \(dateFormatter.string(from: dueDate))")
                                .font(.headline)
                                .font(.headline)
                                .padding(4)
                        }
                    }
                }
                .padding() // Adding padding around the VStack containing all views
                .background(Color(.gray).cornerRadius(15.0).shadow(radius: 30))
                .padding() // Adding padding around the background rectangle
            }
//            .navigationTitle("Book Details") // Setting the navigation title
            .padding(.top,85)
            .ignoresSafeArea()
        }
    }
}

// A view for date picker
struct DatePickerView: View {
    @Binding var selectedDates: Set<DateComponents>
    @State private var showAlert = false // State variable to manage alert presentation
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            Text("Pick the date you want to borrow the book until")
                .font(.headline)
                .padding()

            DatePicker("Select Date", selection: $selectedDate, in: Date()...tenDaysFromNow, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding()

            Button("Confirm") {
                printSelectedDates()
                showAlert = true // Show the alert when the button is pressed
            }
            .padding()
            .alert(isPresented: $showAlert) { // Alert presentation
                let borrowedDays = calculateBorrowedDays()
                let confirmationMessage = "The book has been borrowed until \(dateFormatter.string(from: selectedDate)).\nTotal Borrowed Days: \(borrowedDays) days."
                
                return Alert(
                    title: Text("Confirmation"),
                    message: Text(confirmationMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Select Date")
    }

    var tenDaysFromNow: Date {
        return Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
    }

    // Function to print selected dates
    func printSelectedDates() {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        if let date = calendar.date(from: dateComponents) {
            print("Selected Date: \(date)")
        }
    }

    // Function to calculate borrowed days
    func calculateBorrowedDays() -> Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let selectedDateStartOfDay = calendar.startOfDay(for: selectedDate)
        let borrowedDays = calendar.dateComponents([.day], from: currentDate, to: selectedDateStartOfDay).day ?? 0
        return borrowedDays
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

// Preview provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
