//
//  UIColor Extensions.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 22.05.2023.
//

import UIKit

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 60, height: 60)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 60)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    static var taskRed = { UIColor(named: "TaskRed") ?? UIColor.red }
    static var taskMint = { UIColor(named: "TaskMint") ?? UIColor.systemMint }
}
