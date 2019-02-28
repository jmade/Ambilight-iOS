//
//  AmbilightOnHandler.swift
//  TVPowerOn
//
//  Created by Justin Madewell on 9/18/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import Foundation

class AmbilightOnHandler: NSObject, AmbilightOnIntentHandling {
    let action = "Ambilight ON"
    
    func handle(intent: AmbilightOnIntent, completion: @escaping (AmbilightOnIntentResponse) -> Void) {
        let messageController = MessageInfoController()
        messageController.sendAction(action) { (messageResponse) in
            if let messageResponse = messageResponse {
                completion(AmbilightOnIntentResponse.success(serverMessage: messageResponse.serverMessage))
            } else {
                completion(AmbilightOnIntentResponse.success(serverMessage: "No Message"))
            }
        }
    }
    
    func confirm(intent: AmbilightOnIntent, completion: @escaping (AmbilightOnIntentResponse) -> Void) {
        completion(AmbilightOnIntentResponse(code: .ready, userActivity: nil))
    }
}
