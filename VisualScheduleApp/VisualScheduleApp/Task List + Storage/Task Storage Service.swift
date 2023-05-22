//
//  Task Storage Service.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 20.05.2023.
//

import UIKit

protocol TaskStorageService {
    var taskList: [Task] { get }
    
    func firstRunCheck()
    func add(task: Task)
    func remove(taskNumber: Int)
    func replace(taskNumber: Int, with task: Task)
}

final class TaskStorageServiceImplementation: TaskStorageService {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case task, position
    }
    
    var taskList: [Task] {
        get {
            guard let data = userDefaults.data(forKey: Keys.task.rawValue), let taskList = try? decoder.decode(TaskList.self, from: data) else {
                return [Task]()
            }
            return taskList.tasks
        }
        set {
            let newList = TaskList(tasks: newValue)
            guard let data = try? encoder.encode(newList) else {
                print("error while encoding tasks for storage")
                return
            }
            userDefaults.set(data, forKey: Keys.task.rawValue)
        }
    }
    
    func add(task: Task) {
        var currentList = taskList
        currentList.append(task)
        taskList = currentList
    }
    
    func firstRunCheck() {
        if !userDefaults.bool(forKey: "setup") {
            userDefaults.set(true, forKey: "setup")
            taskList = [Task]()
        }
    }
    
    func remove(taskNumber: Int) {
        var currentList = taskList
        currentList.remove(at: taskNumber)
        taskList = currentList
    }
    
    func replace(taskNumber: Int, with task: Task) {
        var currentList = taskList
        currentList[taskNumber] = task
        taskList = currentList
    }
    
}
