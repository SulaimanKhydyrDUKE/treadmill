//
//  ContentView.swift
//  Treadmill
//
//  Created by Sulaiman Khydyr uulu on 12/31/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            // This will be your Daily Dashboard later
            NavigationStack {
                VStack {
                    Image(systemName: "figure.walk.treadmill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    Text("Daily Dashboard coming soon!")
                        .font(.headline)
                }
                .navigationTitle("Treadmill")
            }
            .tabItem {
                Label("Daily", systemImage: "list.bullet.clipboard")
            }

            // The Profile Page we just built
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [UserProfile.self, LongTermGoal.self], inMemory: true)
}
