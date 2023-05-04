//
//  Task.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit

struct Task {
    var symbol: String
    var title: String
    var description: String
    var color: UIColor
    var isActive: Bool
    
    init(symbol: String = "🦦", title: String = "Test", description: String = "MIC CHECK 1-2", color: UIColor = .blue, isActive: Bool = true) {
        self.symbol = symbol
        self.title = title
        self.description = description
        self.color = color
        self.isActive = isActive
    }
}
