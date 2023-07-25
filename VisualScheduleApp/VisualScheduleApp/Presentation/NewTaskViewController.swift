//
//  NewTaskViewController.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 20.05.2023.
//

import UIKit
import MCEmojiPicker
import ColorKit

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
                                   color: color, isActive: prioritySwitch.isOn, isCurrent: task.isCurrent,
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
        var colors: [UIColor] = []
        if task?.symbol == "?" { return .lightGray }
        do { colors = try emojiImage.dominantColors() } catch { return .gray }
        let palette = ColorPalette(orderedColors: colors, ignoreContrastRatio: true)
        var color = UIColor.gray
        
        guard let bgColor = palette?.background,
              let accentColor = palette?.secondary else { return .gray }
        
        if bgColor.saturation < accentColor.saturation {
            color = accentColor.withBrightness(1)?.withSaturation(0.6) ?? accentColor
        } else {
            color = bgColor.withBrightness(1)?.withSaturation(0.6) ?? bgColor
        }
        if color.luminance > 0.85 {
            color = color.withBrightness(0.85) ?? .gray
        }
        return color
        }
    
    func getDarkColorScheme(from emojiImage: UIImage) -> UIColor {
        var colors: [UIColor] = []
        if task?.symbol == "?" { return .darkGray }
        do { colors = try emojiImage.dominantColors() } catch { return .gray }
        let palette = ColorPalette(orderedColors: colors, ignoreContrastRatio: true)
        var color = UIColor.gray
        
        guard let bgColor = palette?.background,
              let accentColor = palette?.secondary else { return .gray }
        
        if bgColor.saturation < accentColor.saturation {
            color = accentColor.withBrightness(0.8)?.withSaturation(0.8) ?? accentColor
        } else {
            color = bgColor.withBrightness(0.8)?.withSaturation(0.8) ?? bgColor
        }
        if color.luminance < 0.25 {
            color = color.withBrightness(0.78) ?? .gray
        }
        if color.luminance < 0.85 {
            color = color.withBrightness(0.78) ?? .gray
        }
        return color
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
