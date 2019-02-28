//
//  IntentViewController.swift
//  TVPowerOnUI
//
//  Created by Justin Madewell on 9/14/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        
//        print(" interaction -> \(interaction) ")
//
//        guard extensionContext != nil else {
//            completion(false, [], .zero)
//            return
//        }
        
        
        if interaction.intent is VolumeUpIntent {
            if interaction.intentResponse is VolumeUpIntentResponse {
                addVC(IntentVisualViewController((interaction.intentResponse as! VolumeUpIntentResponse).serverMessage!))
            }
            let viewSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            completion(true, [], viewSize)
            return
        }
        
        if interaction.intent is TVPowerOnIntent {
            if interaction.intentResponse is TVPowerOnIntentResponse {
                addVC(IntentVisualViewController((interaction.intentResponse as! TVPowerOnIntentResponse).serverMessage!))
            }
            let viewSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            completion(true, [], viewSize)
            return
        }
        
        
        // AmbilightOn
        if interaction.intent is AmbilightOnIntent {
            if interaction.intentResponse is  AmbilightOnIntentResponse {
                addVC(IntentVisualViewController((interaction.intentResponse as! AmbilightOnIntentResponse).serverMessage!))
            }
            let viewSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            completion(true, [], viewSize)
            return
        }
        
        // Select
        if interaction.intent is SelectIntent {
            if interaction.intentResponse is SelectIntentResponse {
                addVC(IntentVisualViewController((interaction.intentResponse as! SelectIntentResponse).serverMessage!))
            }
            let viewSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            completion(true, [], viewSize)
            return
        }
        
   
        
    }
    
        
}


extension IntentViewController {
    private func addVC(_ vc:UIViewController) {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = view.bounds
        vc.didMove(toParent: self)
        
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func instantiateAndInstall<VC:UIViewController>(ofType type: VC.Type) -> VC {
        let vc = VC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = view.bounds
        vc.didMove(toParent: self)
        
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        return vc
    }
}

extension IntentViewController: INUIHostedViewSiriProviding {
    var displaysMessage: Bool {
        return true
    }
}



