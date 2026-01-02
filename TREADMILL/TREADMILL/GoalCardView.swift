import SwiftUI
import SwiftData

struct GoalCardView: View {
    let goal: LongTermGoal
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(goal.category.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(goal.title)
                .font(.headline)
                .lineLimit(2)
            Text(goal.details)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding()
        .frame(width: 170, height: 140)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(5)
        .shadow(color: .red.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
#Preview {
    GoalCardView(goal: LongTermGoal(title: "Run a Marathon", details: "Complete a full 42km run by the end of the year.", category: "Call", ownerID: "String"))
        .modelContainer(for: [UserProfile.self, LongTermGoal.self], inMemory: true)
}
