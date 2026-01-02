import SwiftUI
import SwiftData
import PhotosUI

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var isShowingAddGoal = false
    @State private var isShowingEditProfile = false
    @State private var selectedGoal: LongTermGoal?
    
    // For editing
    @State private var editedName = ""
    @State private var editedBio = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var editedImageData: Data?
    
    // Get the first profile, or a temporary one for the preview
    private var user: UserProfile {
        profiles.first ?? UserProfile(name: "User", bio: "Bio")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // ... Header Section ...
                VStack(spacing: 15) {
                    if let data = user.profileImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.blue.gradient)
                            .frame(width: 100, height: 100)
                            .overlay(Text(user.name.prefix(1)).font(.largeTitle).bold().foregroundColor(.white))
                    }
                    
                    VStack(spacing: 5) {
                        Text(user.name)
                            .font(.title2)
                            .bold()
                        Text(user.bio)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button("Edit Profile") {
                            editedName = user.name
                            editedBio = user.bio
                            editedImageData = user.profileImageData
                            isShowingEditProfile = true
                        }
                        .font(.caption)
                        .padding(.top, 5)
                    }
                }
                .padding(.top)

                // 2. Stats Section
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
                        // Button now toggles the 'Add Goal' sheet
                        Button(action: { isShowingAddGoal = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(user.longTermGoals) { goal in
                                GoalCardView(goal: goal)
                                    .onTapGesture {
                                        selectedGoal = goal
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $isShowingAddGoal) {
            if let firstProfile = profiles.first {
                AddGoalView(user: firstProfile)
            }
        }
        .sheet(isPresented: $isShowingEditProfile) {
            NavigationStack {
                Form {
                    Section("Profile Picture") {
                        HStack {
                            Spacer()
                            VStack {
                                if let data = editedImageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 80, height: 80)
                                        .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                                }
                                
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    Text("Change Photo")
                                        .font(.caption)
                                }
                            }
                            Spacer()
                        }
                    }
                    
                    Section("Your Info") {
                        TextField("Name", text: $editedName)
                        TextField("Bio", text: $editedBio)
                    }
                }
                .navigationTitle("Edit Profile")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { isShowingEditProfile = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            user.name = editedName
                            user.bio = editedBio
                            user.profileImageData = editedImageData
                            try? modelContext.save()
                            isShowingEditProfile = false
                        }
                    }
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            editedImageData = data
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedGoal) { goal in
            EditGoalView(goal: goal)
        }
        .onAppear {
            if profiles.isEmpty {
                let initialProfile = UserProfile(id: UUID().uuidString, name: "Sulaiman Khydyr", bio: "Describe your vision...")
                modelContext.insert(initialProfile)
                try? modelContext.save()
            }
        }
    }

    private func deleteGoal(_ goal: LongTermGoal) {
        modelContext.delete(goal)
        try? modelContext.save()
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: [UserProfile.self, LongTermGoal.self], inMemory: true)
}

