//
//  Task Storage Service.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 20.05.2023.
//

import UIKit
import RealmSwift

protocol TaskStorageService {
    var taskList: [Task] { get }
    
    func updateAllTasks(taskList: [Task])
    
    func checkIfExpired()
    func firstRunCheck()
    func add(task: Task)
    func remove(taskNumber: Int)
    func replace(taskNumber: Int, with task: Task)
}

final class RealmImplementation {
    
    //TODO: NOT ON MAIN THREAD
    
    static var shared = RealmImplementation()
    
    let realm = try! Realm()
}

final class TaskStorageServiceImplementation: TaskStorageService {
    private let calendar = Calendar.current
    let realm = RealmImplementation.shared.realm
    
    var taskList: [Task] {
        get {
            let result = realm.objects(RealmTask.self)
            let tasks: [Task] = Array(result).map({
                convertTask(from: $0)
            })
            return tasks
        }
        set {
            let result = realm.objects(RealmTask.self)
            try? realm.write() {
                realm.delete(result)
                newValue.forEach() {
                    let newRealmTask = convertTaskToRealm(from: $0)
                    let copy = realm.create(RealmTask.self, value: newRealmTask, update: .all)
                    realm.add(copy)
                }
            }
        }
    }
    
    private func updateTaskList() {
        let result = realm.objects(RealmTask.self)
        let tasks: [Task] = Array(result).map({
            convertTask(from: $0)
        })
        taskList = tasks
    }

    private func convertTaskToRealm(from task: Task) -> RealmTask {
        let realmTask = RealmTask(symbol: task.symbol,
                                  title: task.title,
                                  description: task.fullDescription,
                                  isActive: task.isActive,
                                  isCurrent: task.isCurrent,
                                  colorLight: task.colorLight,
                                  colorDark: task.colorDark,
                                  creationDate: task.creationDate,
                                  isExpanded: task.isExpanded)
        
        let subtasks = task.subtaks
        let color = task.color
        
        realmTask.color = color
        
        let realmSubtasks = subtasks.map{
            let newSubtask = RealmSubtask()
            newSubtask.name = $0.name
            newSubtask.isCurrent = $0.isCurrent
            return newSubtask
        }
        
        let subtaskList = List<RealmSubtask>()
        subtaskList.append(objectsIn: realmSubtasks)
        
        realmTask.subtaks = subtaskList
        
        return realmTask
    }
    
    private func convertTask(from realmTask: RealmTask) -> Task {
        var newTask = Task(symbol: realmTask.symbol,
                           title: realmTask.title,
                           fullDescription: realmTask.fullDescription,
                           color: realmTask.color,
                           subtaks: [],
                           isActive: realmTask.isActive,
                           isCurrent: realmTask.isCurrent,
                           colorLight: realmTask.colorLight!,
                           colorDark: realmTask.colorDark!,
                           creationDate: realmTask.creationDate,
                           isExpanded: realmTask.isExpanded)
        let subtasks = realmTask.getSubtaskList().map(){ realmSubtask in
            Subtask(name: realmSubtask.name, isCurrent: realmSubtask.isCurrent)
        }
        newTask.subtaks = subtasks
        
        return newTask
    }
    
    func updateAllTasks(taskList: [Task]) {
        self.taskList = taskList
    }
    
    func checkIfExpired() {
        let unexpiredTasks = taskList.filter { !$0.isCurrent || calendar.isDate($0.creationDate, equalTo: Date(), toGranularity: .day) }
        
        taskList = unexpiredTasks
    }
    
    func firstRunCheck() {

    }
    
    func add(task: Task) {
        taskList.append(task)
    }
    
    func remove(taskNumber: Int) {
        taskList.remove(at: taskNumber)
    }
    
    func replace(taskNumber: Int, with task: Task) {
        taskList[taskNumber] = task
    }
}

