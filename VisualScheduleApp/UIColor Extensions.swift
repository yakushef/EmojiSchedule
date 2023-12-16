//
//  UIColor Extensions.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 22.05.2023.
//

import UIKit

extension UIColor {
    var saturation: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return saturation
    }
    
    func withBrightness(_ brightness: CGFloat) -> UIColor? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        } else {
            return nil
        }
    }
    
    func withSaturation(_ saturation: CGFloat) -> UIColor? {
        var hue: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        } else {
            return nil
        }
    }
}



extension UIColor {
    var luminance: CGFloat {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let red = r < 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4)
        let green = g < 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4)
        let blue = b < 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4)

        return (red * 0.2126) + (green * 0.7152) + (blue * 0.0722)
    }
}

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
    static var taskMint = { UIColor(named: "TaskMint") ?? UIColor.systemGreen }
    
    func getEmojiColor() -> emojiColor {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return emojiColor(r: Float(red), g: Float(green), b: Float(blue))
    }
}
