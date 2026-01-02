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
final class UserProfile: Identifiable {
    var id: String
    var name: String
    var bio: String
    var profileImageData: Data?
    var accountabilityScore: Double
    
    @Relationship(deleteRule: .cascade) 
    var longTermGoals: [LongTermGoal] = []
    
    init(id: String = UUID().uuidString, name: String, bio: String, accountabilityScore: Double = 0.0) {
        self.id = id
        self.name = name
        self.bio = bio
        self.accountabilityScore = accountabilityScore
    }
}

