//
//  ViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskStorage: TaskStorageService!
    var isReallyExpaded = false
    
    var currentTasks: [Task] = []//[Task(symbol: "🐿️" ,color: .red), Task(symbol: "🦫", color: .orange), Task(description: "sdfkhsdkhbfksj \n skjefhlksdf \n skjfhkdl", color: .systemYellow), Task(symbol: "🦔", color: .systemMint)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.isExpanded = isReallyExpaded
        
        let task = currentTasks[indexPath.row]
        
        cell.collapseButton.tag = indexPath.row
        
        cell.setColor(task.color)
        
        cell.emojiLabel.text = task.symbol
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.description
        
        cell.topLine.isHidden = { indexPath.row == 0 }()
        cell.bottomLine.isHidden = { indexPath.row == currentTasks.count - 1 }()
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
    func update() {
        tableView.beginUpdates()
    }
    
    var isExpended: Bool {
        get {
            return isReallyExpaded
        }
        set {
            isReallyExpaded = newValue
        }
    }
    
    func expandedSection(button: UIButton) {
        isExpended = !isReallyExpaded
        print(button.tag)
        tableView.endUpdates()
        //tableView.reloadRows(at: [IndexPath(row: button.tag, section: 0)], with: .automatic)
        
        //tableView.scrollToRow(at: IndexPath(row: button.tag, section: 0), at: .middle, animated: true)
        
    }
}

