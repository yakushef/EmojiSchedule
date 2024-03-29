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
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var subtaskLine: UIView!
    @IBOutlet weak var underline: UIStackView!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var emojiBackground: UIView!
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var emojiButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var subtaskTableView: UITableView!

    @IBOutlet weak var subtaskStackView: UIStackView!
    @IBOutlet weak var collapseButton: UIButton!
    
    var cellTask: Task!
    
    lazy var index = {
        if let indexPath = (self.superview as? UITableView)?.indexPath(for: self) {
            return indexPath.row
        } else { return 0 }
    }
    
    var isExpanded = true
    var isTop = false
    var isBottom = false
    var isRearranging = false
    var color = ""
    var active = false
    var isDone = false
    var label = ""
    
    weak var delegate: TaskCellDelegate?
    
    func emojiToImage(text: String, size: CGFloat) -> UIImage {

            let outputImageSize = CGSize.init(width: size, height: size)
            let baseSize = text.boundingRect(with: CGSize(width: 2048, height: 2048),
                                             options: .usesLineFragmentOrigin,
                                             attributes: [.font: UIFont.systemFont(ofSize: size / 2)], context: nil).size
            let fontSize = outputImageSize.width / max(baseSize.width, baseSize.height) * (outputImageSize.width / 2)
            let font = UIFont.systemFont(ofSize: fontSize)
            let textSize = text.boundingRect(with: CGSize(width: outputImageSize.width, height: outputImageSize.height),
                                             options: .usesLineFragmentOrigin,
                                             attributes: [.font: font], context: nil).size

            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            style.lineBreakMode = NSLineBreakMode.byClipping

        let attr : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font,
                                                    NSAttributedString.Key.paragraphStyle: style,
                                                     NSAttributedString.Key.backgroundColor: UIColor.clear ]

            UIGraphicsBeginImageContextWithOptions(outputImageSize, false, 0)
            text.draw(in: CGRect(x: (size - textSize.width) / 2,
                                 y: (size - textSize.height) / 2,
                                 width: textSize.width,
                                 height: textSize.height),
                                 withAttributes: attr)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
    
    func currentColor() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else {return}
            let accentColor = self.traitCollection.userInterfaceStyle == .dark ? cellTask.colorDark : cellTask.colorLight
            background.layer.borderColor = accentColor.getUIColor().cgColor
            background.backgroundColor = accentColor.getUIColor().withAlphaComponent(active ? 1 : 0.1)
            for cell in subtaskTableView.visibleCells {
                guard let subtaskCell = cell as? SubtaskCell else { return }
                if subtaskCell.textLabel?.alpha == 1 {
                    subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
                } else {
                    subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
                    subtaskCell.dotView.backgroundColor = cellTask.isActive ? background.backgroundColor : .systemBackground
                }
            }
        })
    }
    
    func setInactiveColor() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else {return}
            if self.traitCollection.userInterfaceStyle == .light {
                let color = active ? UIColor.systemGray5 : UIColor.systemGray4
                background.backgroundColor = color.withAlphaComponent(active ? 1 : 0.1)
                background.layer.borderColor = color.cgColor
            } else {
                background.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(active ? 1 : 0.1)
                background.layer.borderColor = UIColor.tertiarySystemBackground.cgColor
            }
            for cell in subtaskTableView.visibleCells {
                guard let subtaskCell = cell as? SubtaskCell else { return }
                if subtaskCell.textLabel?.alpha == 1 {
                    subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
                } else {
                    subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
                    subtaskCell.dotView.backgroundColor = cellTask.isActive ? background.backgroundColor : .systemBackground
                }
            }
        }
        )
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if !isDone { currentColor() }
        else {
            setInactiveColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 1
        
        let clearView = UIView()
        clearView.backgroundColor = .clear
        
        subtaskTableView.backgroundColor = .clear
        subtaskTableView.dataSource = self
        subtaskTableView.delegate = self

        topLine.alpha = 0
        bottomLine.alpha = 0
    }
    
    func updateSubtasks() {

        subtaskTableView.reloadData()

        delegate?.update()
        delegate?.expandedSection(button: collapseButton)
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
    
    
    func resizeCell() {
//        subtaskTableView.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        subtaskTableView.reloadData()
//        subtaskTableView.heightAnchor.constraint(equalToConstant: subtaskTableView.bounds.height).isActive = true
    }
    
    func setColor(_ taskColor: String, isActive: Bool, task: Task, height: Int) {

        cellTask = task
        isDone = cellTask.isCurrent
        active = isActive
        color = taskColor

                background.layer.borderWidth = 4

        emojiBackground.layer.borderWidth = 0
        currentColor()
        label = task.title

        collapseButton.isHidden = task.subtaks.isEmpty
        subtaskLine.isHidden = task.subtaks.isEmpty
        underline.isHidden = task.subtaks.isEmpty
        subtaskStackView.isHidden = task.subtaks.isEmpty
        descriptionLabel.isHidden = task.fullDescription.isEmpty
        
        subtaskTableView.reloadData()
         subtaskTableView.removeConstraints(subtaskTableView.constraints.filter { $0.firstAttribute == .height })
        subtaskTableView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
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
            setInactiveColor()
            
        } else {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.alpha = 1
            descriptionLabel.alpha = 1
            emojiButton.alpha = 1
            currentColor()
        }
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {

        isDone.toggle()
        cellTask.isCurrent = isDone
        taskDoneVisuals()
        delegate?.updateTaskStatus(task: cellTask, index: index())
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.5),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
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
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.alpha = 0.5
                       },
                       completion: { Void in() }
        )
    }
    
    func expand() {
        UIView.animate(withDuration: 0.2, delay: 0, animations: { [weak self] in
            guard let self else { return }
            self.subtaskStackView.alpha = self.isExpanded ? 1 : 0
            self.subtaskStackView.isHidden = !self.isExpanded
            self.subtaskLine.alpha = self.isExpanded ? 1 : 0
            self.subtaskLine.isHidden = !self.isExpanded
        })
        rotateImage(isExpanded)
    }
    
    @IBAction func collapseButtonTapped(_ sender: UIButton) {
        isExpanded.toggle()
        cellTask.isExpanded = isExpanded
        delegate?.updateTaskStatus(task: cellTask, index: index())
        delegate?.update()
        expand()
        delegate?.expandedSection(button: sender)
    }
}

extension TaskCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTask.subtaks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subtaskTableView.dequeueReusableCell(withIdentifier: "subtaskCell")
        guard let subtaskCell = cell as? SubtaskCell else { return SubtaskCell() }
        subtaskCell.selectionStyle = .none
        subtaskCell.textLabel?.text = self.cellTask.subtaks[indexPath.row].name
        if cellTask.subtaks[indexPath.row].isCurrent {
            subtaskCell.textLabel?.alpha = 1
            subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
            subtaskCell.dotView.backgroundColor = .label
        } else {
            subtaskCell.textLabel?.alpha = 0.25
            subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
            subtaskCell.dotView.backgroundColor = cellTask.isActive ? background.backgroundColor : .systemBackground
        }
        subtaskCell.backgroundColor = .clear
        return subtaskCell
    }
}

extension TaskCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellTask.subtaks[indexPath.row].isCurrent.toggle()
        delegate?.updateTaskStatus(task: cellTask, index: index())
        subtaskTableView.deselectRow(at: indexPath, animated: true)
        
        guard let subtaskCell = subtaskTableView.cellForRow(at: indexPath) as? SubtaskCell else { return }
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self else { return }
            if self.cellTask.subtaks[indexPath.row].isCurrent {
                subtaskCell.textLabel?.alpha = 1
                subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
                subtaskCell.dotView.backgroundColor = .label
            } else {
                subtaskCell.textLabel?.alpha = 0.25
                subtaskCell.dotView.layer.borderColor = UIColor.label.cgColor
                subtaskCell.dotView.backgroundColor = cellTask.isActive ? background.backgroundColor : .systemBackground
            }
        })
    }
}
