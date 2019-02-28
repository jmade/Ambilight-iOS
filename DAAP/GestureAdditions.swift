//
//  GestureAdditions.swift
//  Ambilight
//
//  Created by Justin Madewell on 7/9/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import UIKit

extension CGPoint {
    public func toPoint() -> Point {
        return Point(Int(x),Int(y))
    }
}


extension ATVCommander {
    // to use gestures,
    // first once the gesture state changes into moving
    public static func handleCGPoint(_ cgPoint:CGPoint) {
        
    }
    
    public static func handleStreamOfPoints(_ points:[Point]) {
        
    }
    
    public static func handleGestureRecognizer(_ sender:UIGestureRecognizer) {
        switch sender.state {
        case .possible:
            break
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }
    
}


class TouchPadView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touchPoint = touches.first?.location(in: touches.first?.view) {
            print("Touches Began: \(touchPoint.toPoint())")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touchPoint = touches.first?.location(in: touches.first?.view) {
            print("Touches Moved: \(touchPoint.toPoint())")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let touchPoint = touches.first?.location(in: touches.first?.view) {
            print("Touches Ended: \(touchPoint.toPoint())")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if let touchPoint = touches.first?.location(in: touches.first?.view) {
            print("Touches Cancelled: \(touchPoint.toPoint())")
        }
    }
    
    
}

