import SwiftUI
import SwiftData


struct Daily: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var isShowingAddDailyGoal = false
    
    private var user: UserProfile {
        profiles.first ?? UserProfile(name: "User", bio: "Bio")
    }

    var body: some View {
        TabView {
            // 1. Daily Dashboard
            NavigationStack {
                VStack(spacing: 20) {
                    if user.dailyGoals.isEmpty {
                        Image(systemName: "figure.walk.treadmill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        Text("Your treadmill is empty!")
                            .font(.headline)
                        Text("Add a daily goal to get moving.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        List {
                            ForEach(user.dailyGoals) { goal in
                                HStack {
                                    Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(goal.isCompleted ? .green : .gray)
                                        .onTapGesture {
                                            goal.isCompleted.toggle()
                                            try? modelContext.save()
                                        }
                                    
                                    VStack(alignment: .leading) {
                                        Text(goal.title)
                                            .font(.headline)
                                            .strikethrough(goal.isCompleted)
                                        Text(goal.date, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Treadmill")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isShowingAddDailyGoal = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddDailyGoal) {
                    if let firstProfile = profiles.first {
                        AddDailyGoalView(user: firstProfile)
                    }
                }
            }
            .tabItem {
                Label("Daily", systemImage: "list.bullet.clipboard")
            }

            // 2. The Profile Page
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    Daily()
        .modelContainer(for: [UserProfile.self, LongTermGoal.self, DailyGoal.self], inMemory: true)
}
