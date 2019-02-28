//
//  Select.swift
//  TVPowerOn
//
//  Created by Justin Madewell on 9/18/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import Foundation

class SelectHandler: NSObject, SelectIntentHandling {
    let action = "Select"
    
    func handle(intent: SelectIntent, completion: @escaping (SelectIntentResponse) -> Void) {
        
        let messageController = MessageInfoController()
        messageController.sendAction(action) { (messageResponse) in
            if let messageResponse = messageResponse {
                completion(SelectIntentResponse.success(serverMessage: messageResponse.serverMessage))
            } else {
                completion(SelectIntentResponse.success(serverMessage: "No Message"))
            }
        }
    }
    
    func confirm(intent: SelectIntent, completion: @escaping (SelectIntentResponse) -> Void) {
        completion(SelectIntentResponse(code: .ready, userActivity: nil))
    }
}
