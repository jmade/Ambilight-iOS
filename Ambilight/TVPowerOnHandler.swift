import Foundation

class TVPowerOnHandler: NSObject, TVPowerOnIntentHandling {
    let action = "TV Power On"
    
    func confirm(intent: TVPowerOnIntent, completion: @escaping (TVPowerOnIntentResponse) -> Void) {
        completion(TVPowerOnIntentResponse(code: .ready, userActivity: nil))
    }
    
    func handle(intent: TVPowerOnIntent, completion: @escaping (TVPowerOnIntentResponse) -> Void) {
        let messageInfoController = MessageInfoController()
        messageInfoController.sendAction(action){ (messageResponse) in
            if let messageResponse = messageResponse {
                completion(TVPowerOnIntentResponse.success(serverMessage: messageResponse.serverMessage))
            } else {
                completion(TVPowerOnIntentResponse.success(serverMessage: "No Message"))
            }
        }
    }
    
}
