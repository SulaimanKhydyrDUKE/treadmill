import SwiftUI
import SwiftData

struct Daily: View {
    var body: some View {
        TabView {
            // 1. Daily Dashboard
            NavigationStack {
                VStack(spacing: 20) {
                    Image(systemName: "figure.walk.treadmill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    Text("Daily Dashboard coming soon!")
                        .font(.headline)
                    Text("This is where you'll see your daily treadmill goals.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .navigationTitle("Treadmill")
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
    ContentView()
        .modelContainer(for: [UserProfile.self, LongTermGoal.self], inMemory: true)
}
