//
//  NewTaskViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 20.05.2023.
//

import UIKit

class NewTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var nameField: UITextField!
    
    @IBOutlet weak var colorSelector: UISegmentedControl!
    
    var storage: TaskStorageService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .taskRed()
        nameField.delegate = self
        
        storage = TaskStorageServiceImplementation()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //saveTask(nil)
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

    @IBAction func saveTask(_ sender: Any?) {
        
        guard let nameText = nameField.text, !nameText.isEmpty else {
            return
        }
        
        var color: TaskColors
        
        switch colorSelector.selectedSegmentIndex {
        case 0:
            color = .taskRed
        case 1:
            color = .taskMint
        default:
            color = .taskRed
        }
        
        let newTask = Task(title: nameText, color: color)
        storage.add(task: newTask)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func colorChanged(_ sender: Any) {
        var color: UIColor
        
        switch colorSelector.selectedSegmentIndex {
        case 0:
            color = .taskRed()
        case 1:
            color = .taskMint()
        default:
            color = .taskRed()
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = color
        })
    }
    
}
