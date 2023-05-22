//
//  EditTaskViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 20.05.2023.
//

import UIKit

class EditTaskViewController: UIViewController, UITextFieldDelegate {
    
    var storage: TaskStorageServiceImplementation!
    
    var editedTask: Task!{
        didSet {
            guard isViewLoaded else {
                return
            }
            taskNameLabel.text = editedTask.title
        }
    }
    
    var taskNumber: Int!
    
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var colorSelector: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        storage = TaskStorageServiceImplementation()
        taskNameLabel.text = editedTask.title
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //okButtonTapped(nil)
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        storage.remove(taskNumber: taskNumber)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonTapped(_ sender: Any?) {
        
        guard let nameText = nameTextField.text, !nameText.isEmpty else {
            return
        }
        
        editedTask.title = nameText
        storage.replace(taskNumber: taskNumber, with: editedTask)
        navigationController?.popViewController(animated: true)
    }
    
}
