//
//  ViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit

final class TaskTableView: UITableView {
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        let subviewClass = String(describing: type(of: subview))
        if subviewClass == "UIShadowView" {
            subview.isHidden = true
        }
    }
    
}

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var taskStorage: TaskStorageService!
    var isReallyExpaded = false
    
    var currentTasks: [Task] = []//[Task(symbol: "🐿️" ,color: .red), Task(symbol: "🦫", color: .orange), Task(description: "sdfkhsdkhbfksj \n skjefhlksdf \n skjfhkdl", color: .systemYellow), Task(symbol: "🦔", color: .systemMint)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isEditing = false
        tableView.sectionIndexTrackingBackgroundColor = .clear
        tableView.sectionIndexBackgroundColor = .clear
       // tableView
        //navigationController?.navigationItem.rightBarButtonItem = editButtonItem
        
        // MARK: - User Defaults
        taskStorage = TaskStorageServiceImplementation()
        taskStorage.firstRunCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editor" {
            guard let viewController = segue.destination as? EditTaskViewController, let indexPath = sender as? IndexPath else { return }
            viewController.editedTask = currentTasks[indexPath.row]
            viewController.taskNumber = indexPath.row
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: CELL GONFIG
    
    func configureCell(cell: TaskCell, indexPath: IndexPath) {
        
        cell.delegate = self
        cell.index = indexPath.row
        
        let task = currentTasks[indexPath.row]
        
        cell.collapseButton.tag = indexPath.row
        
        cell.setColor(task.color, isActive: task.isActive, task: task)
        
        cell.emojiButton.setTitle(task.symbol, for: .normal)
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.description
        
        cell.isTop = { indexPath.row == 0 }()
        cell.isBottom = { indexPath.row == currentTasks.count - 1 }()
        cell.isRearranging = isEditing
        
        cell.configureTimeline()
    }
    
    private func updateTasks() {
        currentTasks = taskStorage.taskList
        tableView.reloadData()
    }
    
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 100.0
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "editor", sender: indexPath)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        guard let taskCell = cell as? TaskCell else {
            return UITableViewCell()
        }
        
        configureCell(cell: taskCell, indexPath: indexPath)
        
        return taskCell
    }

}

extension TaskListViewController: TaskCellDelegate {
    
    func updateTaskStatus(task: Task, index: Int) {
        taskStorage.replace(taskNumber: index, with: task)
    }
    
    
    func reorderingCells(isActive: Bool) {
        if isActive {
           // tableview.reloadSections(IndexSet(integer: 0), with: .none)
        } else {
            
        }
    }
    
    
    func update() {
        tableView.beginUpdates()
    }
    
//    var isExpended: Bool {
//        get {
//            return isReallyExpaded
//        }
//        set {
//            isReallyExpaded = newValue
//        }
//    }
    
    func expandedSection(button: UIButton) {
        //isExpended = !isReallyExpaded
        print(button.tag)
        tableView.endUpdates()
        
        //tableView.scrollToRow(at: IndexPath(row: button.tag, section: 0), at: .middle, animated: true)
        
    }
}

//MARK: - EDITING

extension TaskListViewController {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.currentTasks[sourceIndexPath.row]
        currentTasks.remove(at: sourceIndexPath.row)
        currentTasks.insert(movedObject, at: destinationIndexPath.row)
        //let cell = tableView.cellForRow(at: destinationIndexPath) as? TaskCell
        //cell?.configureTimeline()
        for j in 0..<tableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: j, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? TaskCell
            // call your function here
            //cell?.isRearranging = isEditing
            cell?.configureTimeline()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    @IBAction func editMode() {
        let editingState = !self.tableView.isEditing
        self.setEditing(editingState, animated: true)
        if !editingState {
//            self.tableView.beginUpdates()
//            for j in 0..<tableView.numberOfRows(inSection: 0) {
//                let indexPath = IndexPath(row: j, section: 0)
//                let cell = tableView.cellForRow(at: indexPath) as? TaskCell
//                // call your function here
//                cell?.isRearranging = isEditing
//                cell?.configureTimeline()
//            }
//            self.tableView.endUpdates()
            editButton.title = "Edit"
            self.taskStorage.updateAllTasks(taskList: currentTasks)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
               // self.tableView.performBatchUpdates{
                    self.tableView.beginUpdates()
                 //   self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                    for j in 0..<self.tableView.numberOfRows(inSection: 0) {
                        let indexPath = IndexPath(row: j, section: 0)
                        let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell
                        // call your function here
                        cell?.isRearranging = self.isEditing
                        cell?.isTop = { j == 0 }()
                        cell?.isBottom = { j == self.currentTasks.count - 1 }()
                        cell?.configureTimeline()
                    }
                    self.tableView.endUpdates()
               // }
            }
        } else {
            self.tableView.beginUpdates()
            for j in 0..<tableView.numberOfRows(inSection: 0) {
                let indexPath = IndexPath(row: j, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as? TaskCell
                // call your function here
                cell?.isRearranging = isEditing
                cell?.configureTimeline()
            }
            self.tableView.endUpdates()
            editButton.title = "Done"
        }
    }
}

