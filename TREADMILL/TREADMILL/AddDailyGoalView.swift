import SwiftUI
import SwiftData

struct AddDailyGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var date: Date = .now
    
    var user: UserProfile
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Daily Task") {
                    TextField("What's on your treadmill today?", text: $title)
                }
                
                Section("Date") {
                    DatePicker("Target Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New Daily Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        saveDailyGoal()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveDailyGoal() {
        let newGoal = DailyGoal(title: title, ownerID: user.id, date: date)
        user.dailyGoals.append(newGoal)
        try? modelContext.save()
        dismiss()
    }
}

