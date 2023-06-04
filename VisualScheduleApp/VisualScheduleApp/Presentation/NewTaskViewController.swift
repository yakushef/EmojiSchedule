//
//  NewTaskViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 20.05.2023.
//

import UIKit
import MCEmojiPicker

class NewTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var colorSelector: UISegmentedControl!
    @IBOutlet weak var descriptionField: UITextView!
    
    var storage: TaskStorageService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .taskRed()
        nameField.delegate = self
        
        storage = TaskStorageServiceImplementation()
        setupToHideKeyboardOnTapOnView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //saveTask(nil)
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
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
        
        let emojiList = ["👿", "💀", "☠️", "💩", "🤡", "👻", "👽", "👾", "🤖", "🎃", "🎅", "🎄", "🎁", "🎂", "🍰", "🧁", "🍭", "🍬", "🍫", "🍔", "🍟", "🍕", "🍎", "🍌", "🍉", "🍇", "🍓", "🥝", "🥕", "🥦", "🍾", "🥂", "🍸", "🍷", "🍺", "🍻", "🥃", "🍹", "🍩", "🍪", "🍫", "🍔", "🍟", "🍕", "🍞", "🥐", "🥖", "🍜", "🍲", "🥪", "🍳", "🥚", "🥓", "🥩", "🍗", "🍖", "🥗", "🍰", "🎂", "🧇", "🥞", "🍦", "🍨", "🍧", "🍡", "🍢", "🍣", "🥡", "🐵", "🐒", "🦍", "🦧", "🐶", "🐕", "🦮", "🐕‍🦺", "🐩", "🐺", "🦊", "🦝", "🐱", "🐈", "🦁", "🐯", "🐅", "🐆", "🐴", "🐎", "🦄", "🦓", "🦌", "🦬", "🐮", "🐃", "🐄", "🐷", "🐖", "🐗", "🐏", "🐑", "🐐", "🦙", "🦒", "🐘", "🦏", "🦛", "🐭", "🐁", "🐀", "🐹", "🦔", "🐻", "🐨", "🐼", "🦥", "🦦", "🦨", "🦮", "🐕‍🦺", "🐕‍🦺", "🦩", "🕊️", "🦜", "🦢", "🦆", "🦉", "🐦", "🐧", "🦤", "🦇", "🐺", "🐗", "🐃", "🦛", "🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🛴", "🚲", "🛹", "🛼", "🛺", "🚅", "🚆", "🚇", "🚊", "🚉", "✈️", "🛫", "🛬", "🛩️", "💺", "🚀", "🛸", "🛰️", "🚁", "🛶", "⛵", "🛥️", "🚤", "🛳️", "⛴️", "🚢", "🏠", "🏡", "🏘️", "🏢", "🏬", "🏣", "🏤", "🏥", "🏦", "🏨", "🏪", "🏫", "🏰", "💒", "🗼", "🗽", "⛪", "🕌", "🕍", "⛩️", "🛕", "🎠", "🎡", "🎢", "💈", "🎪", "🚂", "🚃", "🚄", "🛣️", "🛤️", "🛢️", "⛽", "🚨", "🚥", "🚦", "🗺️", "🗾", "🏔️", "⛰️", "🌋", "🗻", "🏕️", "🏖️", "🏜️", "🏝️", "🏞️", "🏟️", "🏛️", "🎭", "🎨", "🌵", "🎄", "🌳", "🌴", "🪵", "🌱", "🌿", "☘️", "🍀", "🎍", "🎋", "🍃", "🍂", "🍁", "🍄", "🌾", "💐", "🌷", "🌹", "🥀", "🌺", "🌸", "🌼", "🌻", "🌞", "🌝", "🌛", "🌜", "🌚", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓", "🌔", "🌙", "🌎", "🌍", "🌏", "🌋", "🌊", "🪨", "🔥", "🌪️", "🌈", "☀️", "🌤️", "⛅", "☁️", "🌦️", "🌧️", "⛈️", "🌩️", "❄️", "🌨️", "☃️", "⛄", "🌬️", "💨", "🌫️", "🌁"]
        
        let newTask = Task(symbol: emojiButton.title(for: .normal) ?? emojiList[Int.random(in: 0..<emojiList.count)], title: nameText, description: descriptionField.text, color: color)
        storage.add(task: newTask)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeEmoji(_ sender: UIButton) {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = sender
        present(viewController, animated: true)
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

extension NewTaskViewController: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
    }
    
    
}

extension NewTaskViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(NewTaskViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {

        view.endEditing(true)
    }
}

extension NewTaskViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
