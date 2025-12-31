import SwiftUI

struct GoalCardView: View {
    let goal: LongTermGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.category.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Text(goal.title)
                .font(.headline)
                .lineLimit(2)
            
            Spacer()
            
            Text(goal.details)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .frame(width: 160, height: 180)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}

