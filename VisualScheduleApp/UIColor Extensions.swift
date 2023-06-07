//
//  UIColor Extensions.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 22.05.2023.
//

import UIKit

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 90)])
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

extension UIColor {
    static var taskRed = { UIColor(named: "TaskRed") ?? UIColor.red }
    static var taskMint = { UIColor(named: "TaskMint") ?? UIColor.systemMint }
    
    func getEmojiColor() -> emojiColor {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return emojiColor(r: Float(red), g: Float(green), b: Float(blue))
    }
}
