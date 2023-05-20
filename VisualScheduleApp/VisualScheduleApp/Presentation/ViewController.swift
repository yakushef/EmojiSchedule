//
//  ViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isReallyExpaded = false
    
    var currentTasks: [Task] = [Task(symbol: "🐿️" ,color: .red), Task(symbol: "🦫", color: .orange), Task(description: "sdfkhsdkhbfksj \n skjefhlksdf \n skjfhkdl", color: .systemYellow), Task(symbol: "🦔", color: .systemMint)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableView.rowHeight = UITableView.automaticDimension
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
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 100.0
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
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

extension ViewController: TaskCellDelegate {
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

