//
//  Views.swift
//  Ambilight
//
//  Created by Justin Madewell on 3/23/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import UIKit

//: MARK: - NEWLOADINGVIEW -
public class NewLoadingView : UIView {
    
    var loadingLabel: UILabel = UILabel()
    var progress: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        
        loadingLabel = UILabel()
        loadingLabel.textColor = .black
        loadingLabel.text = "Loading…"
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progress = UIActivityIndicatorView(style: .gray)
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(progress)
        self.addSubview(loadingLabel)
        
        layout()
    }
    
    func layout(){
        // Progress
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: progress, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: progress, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: progress, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: progress, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 10.0),
            ])
        // Loading Label
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: loadingLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: loadingLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: loadingLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: loadingLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -10.0),
            ])
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("error") }
    
    override public func willRemoveSubview(_ subview: UIView) {
        if (subview == self.progress) {
            self.progress.stopAnimating()
            super.willRemoveSubview(subview)
        }
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.progress.startAnimating()
    }
    
    public func end(){
        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
