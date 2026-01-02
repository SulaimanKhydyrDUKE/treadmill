import SwiftUI
import SwiftData

struct AddGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // The "State" holds what you type as you type it
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var category: String = "Personal"
    
    let categories = ["Personal", "Health", "Career", "Finance", "Social"]
    var user: UserProfile // We pass the user in so we can add the goal to them
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("What is your goal?", text: $title)
                    TextField("Details (e.g., How will you achieve it?)", text: $details, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("New Vision Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        saveGoal()
                    }
                    .disabled(title.isEmpty) // Don't allow empty titles
                }
            }
        }
    }
    
    private func saveGoal() {
        let newGoal = LongTermGoal(title: title, details: details, category: category, ownerID: user.id)
        user.longTermGoals.append(newGoal)
        dismiss() // Close the popup
    }
}

