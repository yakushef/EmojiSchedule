//
//  ViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentTasks: [Task] = [Task(symbol: "🐿️" ,color: .red), Task(symbol: "🦫", color: .orange), Task()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: CELL GONFIG
    
    func configureCell(cell: TaskCell, indexPath: IndexPath) {
        
        let task = currentTasks[indexPath.row]
        
        cell.background.backgroundColor = task.color
        
        cell.emojiLabel.text = task.symbol
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
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
