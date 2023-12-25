//
//  Item.swift
//  forZolo
//
//  Created by Aatmik Panse on 24/12/23.
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
