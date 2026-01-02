import SwiftUI
import SwiftData

struct EditGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var goal: LongTermGoal
    
    let categories = ["Personal", "Health", "Career", "Finance", "Social"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("What is your goal?", text: $goal.title)
                    TextField("Details", text: $goal.details, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Category") {
                    Picker("Category", selection: $goal.category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Button(role: .destructive) {
                        deleteGoal()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Goal")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func deleteGoal() {
        withAnimation {
            modelContext.delete(goal)
            try? modelContext.save()
            dismiss()
        }
    }
}

