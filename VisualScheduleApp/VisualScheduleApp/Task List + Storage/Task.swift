//
//  Task.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit

enum TaskColors: String, Codable {
    case taskRed = "TaskRed"
    case taskMint = "TaskMint"
}

struct Task: Codable {
    var symbol: String
    var title: String
    var description: String
    var color: String
    
    var subtaks: [String]
    
    var isActive: Bool
    var isCurrent: Bool
    
    init(symbol: String = "🦦", title: String = "Test", description: String = "MIC CHECK 1-2", color: TaskColors = .taskRed, isActive: Bool = true) {
        self.symbol = symbol
        self.title = title
        self.description = description
        self.color = color.rawValue
        
        self.subtaks = [String]()
        
        self.isActive = isActive
        self.isCurrent = false
    }
}

struct TaskList: Codable {
    var tasks: [Task]
}
