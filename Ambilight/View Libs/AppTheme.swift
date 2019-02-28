//
//  AppTheme.swift
//  Ambilight
//
//  Created by Justin Madewell on 3/23/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import UIKit

public struct App {
    
    static func successFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
    }
    
}


public struct AppTheme {
    
    static func apply(){
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().largeTitleTextAttributes = attrs
        }
        
        UINavigationBar.appearance().barTintColor = AppTheme.Colors.app
        UINavigationBar.appearance().tintColor = AppTheme.Colors.tint
        
        UIToolbar.appearance().barTintColor = AppTheme.Colors.app
        UIToolbar.appearance().tintColor = AppTheme.Colors.tint
        
        UIBarButtonItem.appearance().tintColor = AppTheme.Colors.tint
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : AppTheme.Colors.app ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
    }
    
    struct Colors {
        static let tint = UIColor.white
        static let app = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        static let purple = UIColor(red: 72/255, green: 59/255, blue: 141/255, alpha: 1.0)
        static let originalRed = UIColor(red: 151/255, green: 25/255, blue: 27/255, alpha: 1.0)
        static let yellow = UIColor(red: 240/255, green: 230/255, blue: 140/255, alpha: 1.0)
        static let grey = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
        static let brown = UIColor(red: 129/255, green: 84/255, blue: 27/255, alpha: 1.0)
        static let darkGrey = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        static let oldGrey = UIColor(white: 0.829, alpha: 1.0)
        static let outlineCG = UIColor.black.withAlphaComponent(0.2).cgColor
        static let otherGray = UIColor(white: 0.329, alpha: 1.0)
        static let blue = UIColor(red: 0.1484768369, green: 0.4156247894, blue: 1, alpha: 1)
        static let green = #colorLiteral(red: 0, green: 0.4862745106, blue: 0.1439685175, alpha: 1)
        static let headerGray = UIColor(red: 198/255, green: 198/255, blue: 203/255, alpha: 1.0)
        
        static func originalColor() -> UIColor {
            return UIColor(red: 151/255, green: 25/255, blue: 27/255, alpha: 1.0)
        }
        
    }
    
    
    
    struct Image {
        static let whiteChevronDown: UIImage = chevronDownImage(.white)
        static let blackChevronDown: UIImage = chevronDownImage()
        static let whiteChevronLeft: UIImage = chevronLeftImage(.white)
        static let blackChevronLeft: UIImage = chevronLeftImage()
        
        fileprivate
        static func chevronDownImage(_ color:UIColor = .black, _ squaredSize:CGFloat = 90.0) -> UIImage {
            let imageSize = CGSize(width: squaredSize, height:squaredSize)
            func chevronImage(_ path:UIBezierPath,_ size:CGSize,_ color:UIColor) -> UIImage {
                defer { UIGraphicsEndImageContext() }
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                color.setStroke()
                path.stroke()
                let image = UIGraphicsGetImageFromCurrentImageContext()!
                return image
            }
            return chevronImage(Path.makeChevronDownPath(imageSize.width), imageSize, color)
        }
        
        fileprivate
        static func chevronLeftImage(_ color:UIColor = .black, _ squaredSize:CGFloat = 90.0) -> UIImage {
            let imageSize = CGSize(width: squaredSize, height:squaredSize)
            func chevronImage(_ path:UIBezierPath,_ size:CGSize,_ color:UIColor) -> UIImage {
                defer { UIGraphicsEndImageContext() }
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                color.setStroke()
                path.stroke()
                let image = UIGraphicsGetImageFromCurrentImageContext()!
                return image
            }
            return chevronImage(Path.makeChevronLeftPath(imageSize.width), imageSize, color)
        }
        
        
        
        struct Path {
            static
                fileprivate
                func makeChevronDownPath(_ size:CGFloat,_ length:CGFloat = 0.5) -> UIBezierPath {
                let path = UIBezierPath()
                path.lineCapStyle = .round
                path.lineJoinStyle = .round
                path.lineWidth = size/10
                let inset = (size - (size * length))/2
                let topInset = inset
                let bottomInset = size - inset
                let start = CGPoint(x:path.lineWidth, y: topInset+path.lineWidth)
                let mid = CGPoint(x: size/2, y: bottomInset)
                let end = CGPoint(x: size-path.lineWidth, y: topInset+path.lineWidth)
                path.move(to: start)
                path.addLine(to: mid)
                path.move(to: end)
                path.addLine(to: mid)
                path.close()
                return path
            }
            
            
            static
                fileprivate
                func makeChevronLeftPath(_ size:CGFloat,_ length:CGFloat = 0.5) -> UIBezierPath {
                let path = UIBezierPath()
                path.lineCapStyle = .round
                path.lineJoinStyle = .round
                path.lineWidth = size/10
                let inset = (size - (size * length))/2
                let start = CGPoint(x: inset, y: path.lineWidth)
                let mid = CGPoint(x:size - inset, y: size/2)
                let end = CGPoint(x: inset, y: size - path.lineWidth)
                path.move(to: start)
                path.addLine(to: mid)
                path.move(to: end)
                path.addLine(to: mid)
                path.close()
                return path
            }
        }
    }
}
