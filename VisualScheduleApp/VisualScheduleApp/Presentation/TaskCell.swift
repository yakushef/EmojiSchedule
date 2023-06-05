//
//  TaskCell.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 04.05.2023.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func update()
    func expandedSection(button: UIButton)
    func reorderingCells(isActive: Bool)
    func updateTaskStatus(task: Task, index: Int)
  //  var isExpended: Bool { get set }
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var emojiBackground: UIView!
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var emojiButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var subtaskTableView: UITableView!
    @IBOutlet weak var collapseButton: UIButton!
    
    var cellTask: Task!
    
    var index = 0
    
    var isExpanded = true
    var isTop = false
    var isBottom = false
    var isRearranging = false
    var color = ""
    var active = false
    var isDone = false
    var label = ""
    
    weak var delegate: TaskCellDelegate?
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        background.layer.borderColor = UIColor(named: color)?.cgColor
        background.backgroundColor = UIColor(named: color)?.withAlphaComponent(active ? 1 : 0.1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 1
        
        let clearView = UIView()
        clearView.backgroundColor = .clear
        //backgroundView = clearView
        //backgroundView = blurView
        
        subtaskTableView.backgroundColor = .clear
        subtaskTableView.dataSource = self
        subtaskTableView.delegate = self
        //topLine.isHidden = true
        //bottomLine.isHidden = true
        topLine.alpha = 0
        bottomLine.alpha = 0
    }
    
    func configureTimeline(time: Double = 0.15) {
        
        let interval = TimeInterval(floatLiteral: time)
        
        UIView.animate(withDuration: interval, animations: {
            if self.isRearranging || (self.isTop && self.isBottom) {
                //self.topLine.isHidden = true
                self.topLine.alpha = 0
                //self.bottomLine.isHidden = true
                self.bottomLine.alpha = 0
            } else if self.isTop {
                //self.topLine.isHidden = true
                self.topLine.alpha = 0
                //self.bottomLine.isHidden = false
                self.bottomLine.alpha = 1
            } else if self.isBottom {
                //self.topLine.isHidden = false
                self.topLine.alpha = 1
                //self.bottomLine.isHidden = true
                self.bottomLine.alpha = 0
            } else {
                //self.topLine.isHidden = false
                self.topLine.alpha = 1
                //self.bottomLine.isHidden = false
                self.bottomLine.alpha = 1
            }
        })

    }
    
    func setColor(_ taskColor: String, isActive: Bool, task: Task) {
   //     print(taskColor)
        cellTask = task
        isDone = cellTask.isCurrent
        active = isActive
        color = taskColor
        background.layer.borderColor = UIColor(named: taskColor)?.cgColor
        background.layer.borderWidth = 4
        background.backgroundColor = UIColor(named: taskColor)?.withAlphaComponent(active ? 1 : 0.1)
        emojiBackground.layer.borderWidth = 0
        label = task.title
        taskDoneVisuals()
    }
    
    func rotateImage(_ expanded: Bool) {
        if expanded {
            UIView.animate(withDuration: 0.25, delay: 0, animations: {
                self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, animations: {
                self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
            })
        }
    }

    func taskDoneVisuals() {
        if isDone {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.alpha = 0.5
            descriptionLabel.alpha = 0.5
            emojiButton.alpha = 0.5
        } else {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.alpha = 1
            descriptionLabel.alpha = 1
            emojiButton.alpha = 1
        }
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
//        print("!")
        isDone.toggle()
        cellTask.isCurrent = isDone
        taskDoneVisuals()
        delegate?.updateTaskStatus(task: cellTask, index: index)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.5),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
//                        sender.transform = CGAffineTransform.identity
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            sender.alpha = self.isDone ? 0.5 : 1
                       },
                       completion: { Void in() }
        )
    }
    
    @IBAction func emojiAnim2(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.5),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
//                        sender.transform = CGAffineTransform.identity
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            sender.alpha = self.isDone ? 0.5 : 1
                       },
                       completion: { Void in() }
        )
    }
    
    
    
    
    @IBAction func emojiAnim1(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.5),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
//                        sender.transform = CGAffineTransform.identity
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.alpha = 0.5
                       },
                       completion: { Void in() }
        )
    }
    
    
    
    
    @IBAction func collapseButtonTapped(_ sender: UIButton) {
        isExpanded.toggle()
        delegate?.update()
        UIView.animate(withDuration: 0.25, delay: 0, animations: {
            self.subtaskTableView.isHidden.toggle()
        })
        rotateImage(isExpanded)
        delegate?.expandedSection(button: sender)
    }
}

extension TaskCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "subtaskCell")
        cell.textLabel?.text = "test3000"
        cell.backgroundColor = .clear
        return cell
    }
    
    
}

extension TaskCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subtaskTableView.deselectRow(at: indexPath, animated: true)
    }
}
