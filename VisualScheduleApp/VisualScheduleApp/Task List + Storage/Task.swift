//
//  Task.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit
import RealmSwift

enum TaskColors: String, PersistableEnum {
    case taskRed = "TaskRed"
    case taskMint = "TaskMint"
}

final class RealmSubtask: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var isCurrent: Bool
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.isCurrent = true
    }
}

struct Subtask {
    var name: String
    var isCurrent: Bool
    init(name: String, isCurrent: Bool = true) {
        self.name = name
        self.isCurrent = isCurrent
    }
}

final class emojiColor: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var r: Float
    @Persisted var g: Float
    @Persisted var b: Float
    
    convenience init(r: Float, g: Float, b: Float) {
        self.init()
        self.r = r
        self.g = g
        self.b = b
    }
    
    func getUIColor() -> UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
    
    func getCGColor() -> CGColor {
        return CGColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
}

struct Task {
    var symbol: String
    var title: String
    var fullDescription: String
    var color: String
    
    var subtaks: [Subtask]
    
    var isActive: Bool
    var isCurrent: Bool
    
    var colorLight: emojiColor
    var colorDark: emojiColor
    
    private(set) var creationDate: Date
    
    var isExpanded: Bool
}

final class RealmTask: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var symbol: String
    @Persisted var title: String
    @Persisted var fullDescription: String
    @Persisted var color: String
    
    @Persisted var subtaks: List<RealmSubtask>
    
    @Persisted var isActive: Bool
    @Persisted var isCurrent: Bool
    
    @Persisted var colorLight: emojiColor?
    @Persisted var colorDark: emojiColor?
    
    @Persisted private(set) var creationDate: Date
    
    @Persisted var isExpanded: Bool
    
    convenience init(symbol: String = "🦦", title: String = "Test", description: String = "MIC CHECK 1-2", color: TaskColors = .taskRed, isActive: Bool = true, isCurrent: Bool = false, subtasks: List<RealmSubtask> = List(), colorLight: emojiColor = emojiColor(r: 0, g: 0, b: 0), colorDark: emojiColor = emojiColor(r: 1, g: 1, b: 1), creationDate: Date = Date(), isExpanded: Bool = true) {
        self.init()
        self.symbol = symbol
        self.title = title
        self.fullDescription = description
        self.color = color.rawValue
        
        self.subtaks = subtasks
        
        self.isActive = isActive
        self.isCurrent = isCurrent
        
        self.colorDark = colorDark
        self.colorLight = colorLight
        
        self.isExpanded = isExpanded
        self.creationDate = creationDate
    }
    
    func getSubtaskList() -> [RealmSubtask] {
        return Array(subtaks)
    }
}
