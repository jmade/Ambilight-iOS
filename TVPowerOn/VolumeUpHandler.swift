import Foundation

class VolumeUpHandler: NSObject, VolumeUpIntentHandling {
    let action = "Volume Up"
    
    func confirm(intent: VolumeUpIntent, completion: @escaping (VolumeUpIntentResponse) -> Void) {
        completion(VolumeUpIntentResponse(code: .ready, userActivity: nil))
    }
    
    func handle(intent: VolumeUpIntent, completion: @escaping (VolumeUpIntentResponse) -> Void) {
        let messageController = MessageInfoController()
        messageController.sendAction(action) { (messageResponse) in
            if let messageResponse = messageResponse {
                completion(VolumeUpIntentResponse.success(serverMessage: messageResponse.serverMessage))
            } else {
                completion(VolumeUpIntentResponse.success(serverMessage: "No Message"))
            }
        }
    }
   
}
