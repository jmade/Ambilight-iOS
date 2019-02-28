
import Intents

class IntentHandler: INExtension   {
    
    override func handler(for intent: INIntent) -> Any {
       
        if intent is VolumeUpIntent {
            return VolumeUpHandler()
        }
        
        if intent is TVPowerOnIntent {
            return TVPowerOnHandler()
        }
        
        if intent is AmbilightOnIntent {
            return AmbilightOnHandler()
        }
        
        if intent is SelectIntent {
            return SelectHandler()
        }
        
        return self
    }
    
}
