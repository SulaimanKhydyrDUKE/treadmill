import Foundation
import SwiftData

@Model
final class LongTermGoal {
    var id: UUID
    var title: String
    var details: String
    var category: String // e.g., "Career", "Health", "Personal"
    var createdAt: Date
    
    init(title: String, details: String, category: String = "Personal") {
        self.id = UUID()
        self.title = title
        self.details = details
        self.category = category
        self.createdAt = Date()
    }
}

@Model
final class UserProfile {
    var name: String
    var bio: String
    var profileImageData: Data?
    var accountabilityScore: Double // 0.0 to 1.0 (0% to 100%)
    
    @Relationship(deleteRule: .cascade) 
    var longTermGoals: [LongTermGoal] = []
    
    init(name: String, bio: String, accountabilityScore: Double = 0.0) {
        self.name = name
        self.bio = bio
        self.accountabilityScore = accountabilityScore
    }
}

