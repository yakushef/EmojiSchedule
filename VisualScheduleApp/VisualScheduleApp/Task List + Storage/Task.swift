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

struct emojiColor: Codable {
    var r: Float
    var g: Float
    var b: Float
    
    func getUIColor() -> UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
    
    func getCGColor() -> CGColor {
        return CGColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
}

struct Task: Codable {
    
    var symbol: String
    var title: String
    var description: String
    var color: String
    
    var subtaks: [String]
    
    var isActive: Bool
    var isCurrent: Bool
    
    var colorLight: emojiColor
    var colorDark: emojiColor
    
    let creationDate: Date
    
    init(symbol: String = "🦦", title: String = "Test", description: String = "MIC CHECK 1-2", color: TaskColors = .taskRed, isActive: Bool = true, subtasks: [String] = [], colorLight: emojiColor = emojiColor(r: 0, g: 0, b: 0), colorDark: emojiColor = emojiColor(r: 1, g: 1, b: 1)) {
        self.symbol = symbol
        self.title = title
        self.description = description
        self.color = color.rawValue
        
        self.subtaks = subtasks
        
        self.isActive = isActive
        self.isCurrent = false
        
        self.colorDark = colorDark
        self.colorLight = colorLight
        
        self.creationDate = Date()
    }
}

struct TaskList: Codable {
    var tasks: [Task]
}
