//
//  SubtaskViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 07.06.2023.
//

import UIKit

protocol SubtaskViewControllerDelegate {
    func updateSubtasks(with subtasks: [String])
}

class SubtaskViewController: UIViewController {
    
    var delegate: SubtaskViewControllerDelegate!
    var subtasks: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var subtaskTableView: UITableView!
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let newSubtaskAlert = UIAlertController(title: "New subtask", message: "Enter text below" , preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Done", style: .default) { _ in
            let textField = newSubtaskAlert.textFields?.first
            if let text = textField?.text,
               !text.isEmpty {
                self.subtasks.append(text)
                self.subtaskTableView.reloadData()
            }
        }
        okAction.isEnabled = false
        
        newSubtaskAlert.addTextField { textField in
            textField.placeholder = "Do some part of a bigger task!"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                okAction.isEnabled = !(textField.text?.isEmpty ?? true)}
        }
        

        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        newSubtaskAlert.addAction(okAction)
        newSubtaskAlert.addAction(cancelAction)
        
        present(newSubtaskAlert, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate.updateSubtasks(with: subtasks)
    }
}

extension SubtaskViewController: UITableViewDelegate {
    
}

extension SubtaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "subtaskListCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = subtasks[indexPath.row]
        return cell
    }
    
    
}
