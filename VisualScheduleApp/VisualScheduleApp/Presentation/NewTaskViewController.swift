//
//  NewTaskViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 20.05.2023.
//

import UIKit
import MCEmojiPicker

enum EditorState {
    case add
    case edit
}

class NewTaskViewController: UIViewController, UITextFieldDelegate {
    
    var state: EditorState = .add
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var colorSelector: UISegmentedControl!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var prioritySwitch: UISwitch!
    
    @IBOutlet weak var subtasksTestSwitch: UISwitch!
    
    var storage: TaskStorageService!
    var task: Task? = nil {
        didSet {
            taskSubtasks = task?.subtaks ?? []
        }
    }
    var taskSubtasks: [Subtask] = []
    var taskIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if state == .add {
            navigationItem.title = "Add new task"
            deleteButton.isHidden = true
        } else if state == .edit {
            navigationItem.title = "Edit task"
            deleteButton.isHidden = false
            
            if let task { prioritySwitch.isOn = task.isActive }
            nameField.text = task?.title
            descriptionField.text = task?.description
            emojiButton.setTitle(task?.symbol, for: .normal)
            
            // TODO: make func
            let colorBase = emojiButton.title(for: .normal) ?? "🐚"
            let emojiImage = colorBase.image() ?? UIImage()
            
            let uiColorLight = getLightColorScheme(from: emojiImage)
            let uiColorDark = getDarkColorScheme(from: emojiImage)
            
            let accentColor = self.traitCollection.userInterfaceStyle == .dark ? uiColorDark : uiColorLight
            if emojiButton.titleLabel?.text != "?" {
                view.backgroundColor = accentColor
            }
        }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller
        
        if let vc = segue.destination as? SubtaskViewController {
            vc.subtasks = taskSubtasks
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }


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
        let colorBase = emojiButton.title(for: .normal) ?? emojiList[Int.random(in: 0..<emojiList.count)]
        let emojiImage = colorBase.image() ?? UIImage()
        
        let uiColorLight = getLightColorScheme(from: emojiImage)
        let uiColorDark = getDarkColorScheme(from: emojiImage)
        
        let colorLight = uiColorLight.getEmojiColor()
        
        let colorDark = uiColorDark.getEmojiColor()
        
        switch state {
        case .edit:
            guard let task else { return }
            let updatedTask = Task(symbol: emojiButton.title(for: .normal) ?? task.symbol,
                                   title: nameText, description: descriptionField.text,
                                   color: color, isActive: prioritySwitch.isOn,
                                   subtasks: taskSubtasks,
                                   colorLight: colorLight,
                                   colorDark: colorDark)
            storage.replace(taskNumber: taskIndex, with: updatedTask)
        case .add:
                
            let newTask = Task(symbol: emojiButton.title(for: .normal) ?? emojiList[Int.random(in: 0..<emojiList.count)],
                               title: nameText, description: descriptionField.text,
                               color: color, isActive: prioritySwitch.isOn,
                               subtasks: taskSubtasks,
                               colorLight: colorLight,
                               colorDark: colorDark)
            storage.add(task: newTask)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func changeEmoji(_ sender: UIButton) {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = sender
        present(viewController, animated: true)
    }
    
    
    @IBAction func deleteButtonTapped() {
        storage.remove(taskNumber: taskIndex)
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
    }
}

extension NewTaskViewController: MCEmojiPickerDelegate {
    
    func getLightColorScheme(from emojiImage: UIImage) -> UIColor {
        guard let colors = emojiImage.getColors() else { return .gray }
        let colorArray = [colors.background ?? .gray,
                          colors.detail ?? .gray,
                          colors.primary ?? .gray,
                          colors.secondary ?? .gray]
        
        print(colorArray)
        
        let lightestColor = colorArray.min { $0.luminance < $1.luminance }
        
        return colors.primary ?? .gray
//        var uiColorLight = emojiImage.createPalette().lightVibrantColor
//
//        if uiColorLight == nil {
//            let mitedUIColorLight = emojiImage.createPalette().vibrantColor
//            var hue: CGFloat = 0
//            var sat: CGFloat = 0
//            var bright: CGFloat = 0
//            mitedUIColorLight?.getHue(&hue, saturation: &sat, brightness: &bright, alpha: nil)
////            sat *= 3
//            bright *= 1
//            sat *= 0.7
//            uiColorLight = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
//        } else {
//            var hue: CGFloat = 0
//            var sat: CGFloat = 0
//            var bright: CGFloat = 0
//            uiColorLight?.getHue(&hue, saturation: &sat, brightness: &bright, alpha: nil)
//            bright *= 0.9
//            uiColorLight = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
//        }
//        return uiColorLight ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    
    func getDarkColorScheme(from emojiImage: UIImage) -> UIColor {
        
            guard let colors = emojiImage.getColors() else { return .gray }
        let colorArray = [colors.background ?? .gray,
                              colors.detail ?? .gray,
                              colors.primary ?? .gray,
                              colors.secondary ?? .gray]
        
        print(colorArray)
            
            let darkestColor = colorArray.max { $0.luminance < $1.luminance }
            
            return colors.secondary ?? .gray
        
        
        
//        var uiColorDark = emojiImage.createPalette().mutedColor
//        if uiColorDark == nil {
//            let mitedUIColorDark = emojiImage.createPalette().darkVibrantColor
//            var hue: CGFloat = 0
//            var sat: CGFloat = 0
//            var bright: CGFloat = 0
//            mitedUIColorDark?.getHue(&hue, saturation: &sat, brightness: &bright, alpha: nil)
////            sat *= 2
////            bright *= 0.6
//
//            uiColorDark = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
//        }
//        return uiColorDark ?? UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateColor()
    }
    
    func updateColor() {
        
        let colorBase = emojiButton.title(for: .normal) ?? "🍄"
        
        let emojiImage = colorBase.image() ?? UIImage()
        
        let uiColorLight = getLightColorScheme(from: emojiImage)
        let uiColorDark = getDarkColorScheme(from: emojiImage)
        
        let accentColor = self.traitCollection.userInterfaceStyle == .dark ? uiColorDark : uiColorLight
        view.backgroundColor = accentColor
    }
    
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.updateColor()
        })
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

extension NewTaskViewController: SubtaskViewControllerDelegate {
    func updateSubtasks(with subtasks: [Subtask]) {
        taskSubtasks = subtasks
    }    
    
}
