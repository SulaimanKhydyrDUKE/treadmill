//
//  Item.swift
//  Treadmill
//
//  Created by Sulaiman Khydyr uulu on 12/31/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
