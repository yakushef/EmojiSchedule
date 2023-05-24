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
  //  var isExpended: Bool { get set }
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
    
    var isExpanded = true
    var isTop = false
    var isBottom = false
    var isRearranging = false
    
    weak var delegate: TaskCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subtaskTableView.backgroundColor = .clear
        subtaskTableView.dataSource = self
        subtaskTableView.delegate = self
        //topLine.isHidden = true
        //bottomLine.isHidden = true
        topLine.alpha = 0
        bottomLine.alpha = 0
    }
    
    func configureTimeline() {
        
        
        

        
        UIView.animate(withDuration: 0.25, animations: {
            if self.isRearranging {
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
    
    func setColor(_ taskColor: String) {
   //     print(taskColor)
        background.backgroundColor = UIColor(named: taskColor)
        emojiBackground.layer.borderWidth = 0
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
