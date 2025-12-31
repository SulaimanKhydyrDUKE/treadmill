import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    
    // Safe way to get or create the profile
    private var user: UserProfile {
        if let existingProfile = profiles.first {
            return existingProfile
        } else {
            let newProfile = UserProfile(name: "New User", bio: "Setting my vision...")
            modelContext.insert(newProfile)
            return newProfile
        }
    }

    var body: some View {
        
        ScrollView {
            VStack(spacing: 25) {
                // 1. Header Section
                VStack(spacing: 15) {
                    Circle()
                        .fill(Color.blue.gradient)
                        .frame(width: 100, height: 100)
                        .overlay(Text(user.name.prefix(1)).font(.largeTitle).bold().foregroundColor(.white))
                    
                    VStack(spacing: 5) {
                        Text(user.name)
                            .font(.title2)
                            .bold()
                        Text(user.bio)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top)

                // 2. Stats Section (Accountability Score)
                HStack(spacing: 40) {
                    VStack {
                        Text("\(Int(user.accountabilityScore * 100))%")
                            .font(.title3)
                            .bold()
                        Text("Consistency")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(user.longTermGoals.count)")
                            .font(.title3)
                            .bold()
                        Text("Vision Goals")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.05), radius: 10)

                // 3. Long-Term Vision Section
                VStack(alignment: .leading) {
                    HStack {
                        Text("Long-Term Vision")
                            .font(.headline)
                        Spacer()
                        Button(action: addSampleGoal) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(user.longTermGoals) { goal in
                                GoalCardView(goal: goal)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }

    private func addSampleGoal() {
        let newGoal = LongTermGoal(title: "Run a Marathon", details: "Complete a full 42km run by the end of the year.", category: "Health")
        user.longTermGoals.append(newGoal)
        try? modelContext.save()
    }
    
}

#Preview {
    ProfileView()
        .modelContainer(for: [UserProfile.self, LongTermGoal.self], inMemory: true)
}

