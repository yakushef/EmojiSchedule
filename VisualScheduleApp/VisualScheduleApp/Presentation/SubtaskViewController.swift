//
//  SubtaskViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 07.06.2023.
//

import UIKit

protocol SubtaskViewControllerDelegate {
    func updateSubtasks(with subtasks: [Subtask])
}

class SubtaskViewController: UIViewController {
    
    var delegate: SubtaskViewControllerDelegate!
    var subtasks: [Subtask] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var subtaskTableView: UITableView!
    
    @IBAction func editButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let newSubtaskAlert = UIAlertController(title: "New subtask", message: "Enter text below" , preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Done", style: .default) { _ in
            let textField = newSubtaskAlert.textFields?.first
            if let text = textField?.text,
               !text.isEmpty {
                self.subtasks.append(Subtask(name: text))
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setEditing(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setEditing(false, animated: true)
        delegate.updateSubtasks(with: subtasks)
    }
}

extension SubtaskViewController: UITableViewDelegate {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        subtaskTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subtasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = subtasks[sourceIndexPath.row]
        subtasks.remove(at: sourceIndexPath.row)
        subtasks.insert(item, at: destinationIndexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if tableView.isEditing {
//            return .delete
//        } else {
//            return .none
//        }
//    }
}

extension SubtaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "subtaskListCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = subtasks[indexPath.row].name
        return cell
    }
}
