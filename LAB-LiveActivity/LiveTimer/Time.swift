//
//  Time.swift
//  LiveTimer
//
//  Created by 김민준 on 12/30/24.
//

import Foundation

enum Time: TimeInterval, CaseIterable, Identifiable {
    case test = 0.05
    case min30 = 30
    case min60 = 60
    case min90 = 90
    
    var id: UUID {
        UUID()
    }
    
    var timeFormat: String {
        if self == .test { return "테스트" }
        return "\(Int(self.rawValue))분"
    }
    
    var toSeconds: TimeInterval {
        self.rawValue * 60
    }
}
