import Foundation
import SwiftData

@Model
final class LongTermGoal: Identifiable {
    var id: UUID
    var ownerID: String
    var title: String
    var details: String
    var category: String
    var createdAt: Date
    var user: UserProfile?
    
    init(title: String, details: String, category: String = "Personal", ownerID: String) {
        self.id = UUID()
        self.ownerID = ownerID
        self.title = title
        self.details = details
        self.category = category
        self.createdAt = Date()
    }
}

@Model
final class DailyGoal: Identifiable {
    var id: UUID
    var ownerID: String
    var title: String
    var isCompleted: Bool
    var reflection: String //Why not if not completed? and what you learned if completed?
    var date: Date
    var user: UserProfile?

    init(title: String, isCompleted: Bool = false, reflection: String = "", date: Date = .now, ownerID: String) {
        self.id = UUID()
        self.ownerID = ownerID
        self.title = title
        self.isCompleted = isCompleted
        self.reflection = reflection
        self.date = date
    }
}

@Model
final class UserProfile: Identifiable {
    var id: String
    var name: String
    var bio: String
    var profileImageData: Data?
    var accountabilityScore: Double
    
    @Relationship(deleteRule: .cascade, inverse: \LongTermGoal.user) 
    var longTermGoals: [LongTermGoal] = []
    
    @Relationship(deleteRule: .cascade, inverse: \DailyGoal.user)
    var dailyGoals: [DailyGoal] = []
    
    init(id: String = UUID().uuidString, name: String, bio: String, accountabilityScore: Double = 0.0) {
        self.id = id
        self.name = name
        self.bio = bio
        self.accountabilityScore = accountabilityScore
    }
}
