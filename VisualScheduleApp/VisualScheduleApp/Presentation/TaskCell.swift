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
    var isExpended: Bool { get set }
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var emojiBackground: UIView!
    
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var subtaskTableView: UITableView!
    @IBOutlet weak var collapseButton: UIButton!
    
    var isExpanded = false
    
    weak var delegate: TaskCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subtaskTableView.backgroundColor = .clear
        subtaskTableView.dataSource = self
        subtaskTableView.delegate = self
    }
    
    func setColor(_ taskColor: String) {
        //descriptionLabel.isHidden.toggle()
        //subtaskTableView.isHidden = true
        //background.backgroundColor = color.withAlphaComponent(0.5)
        print(taskColor)
        background.backgroundColor = UIColor(named: taskColor)
        emojiBackground.layer.borderWidth = 0
        //emojiBackground.layer.borderColor = color.cgColor
        //emojiBackground.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        //emojiBackground.backgroundColor = color.withAlphaComponent(0.1)
        //background.layer.cornerRadius = background.frame.height / 2
        //emojiBackground.backgroundColor = UIColor.label
    }
    
    func rotateImage(_ expanded: Bool) {
        if expanded {
            //collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            UIView.animate(withDuration: 0.25, delay: 0, animations: {
                self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
        } else {
            //collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
            UIView.animate(withDuration: 0.25, delay: 0, animations: {
                self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
            })
        }
    }
    
    @IBAction func collapseButtonTapped(_ sender: UIButton) {
        isExpanded.toggle()
        delegate?.update()
        //subtaskTableView.isHidden.toggle()
        UIView.animate(withDuration: 0.25, delay: 0, animations: {
            self.subtaskTableView.isHidden.toggle()
        })
       // subtaskTableView.reloadData()
//        if isExpanded {
//            subtaskTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        } else {
//            subtaskTableView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        }
        //descriptionLabel.text = isExpanded ? "srlkngnlf \n sdklgnlsdgklsdng\n kljnflsdg\neskldfngl\n" : "1"
        rotateImage(isExpanded)
      //  delegate?.update()
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
