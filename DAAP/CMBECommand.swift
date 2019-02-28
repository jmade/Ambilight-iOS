import Foundation

public typealias Point = (Int,Int)

//: MARK: - CommandType -
public enum CommandType: String {
    case touchMove = "touchMove"
    case touchDown = "touchDown"
    case touchUp = "touchUp"
    case select = "select"
    case menu = "menu"
    case topMenu = "topMenu"
}

//: MARK: - CMBECommand -
public struct CMBECommand {
    
    public let type: CommandType
    public let point: Point?
    
    // CMBE Bytes
    public var cmbeBytes:[UInt8] {
        switch type {
        case .touchMove:
            return [0,0,0,29]
        case .touchDown:
            return [0,0,0,29]
        case .touchUp:
            return [0,0,0,27]
        case .select:
            return [0,0,0,6]
        case .menu:
            return [0,0,0,4]
        case .topMenu:
            return [0,0,0,4]
        }
    }
    
    // CMCC Bytes
    public var cmccBytes: [UInt8] {
        return [99, 109, 99, 99, 0, 0, 0, 1, 48, 99, 109, 98, 101]
    }
    
    // Control Bytes
    public var controlBytes: [UInt8] {
        return [ cmccBytes, cmbeBytes ].reduce([],+)
    }
    
    // Command
    public var pointString: String? {
        if let `point` = point {
            return "point=\(point.0),\(point.1)"
        } else {
            return nil
        }
    }
    
    
    // TODO: Need to fix this.
    public var commandString: String {
        if let `pointString` = pointString {
            return "\(type.rawValue)&time=\(time)&\(pointString)"
        } else {
            return "\(type.rawValue)"
        }
    }
    
    public func makeCommandString(_ time:Int) -> String {
        if let `pointString` = pointString {
            return "\(type.rawValue)&time=\(time)&\(pointString)"
        } else {
            return "\(type.rawValue)"
        }
    }
    
    // Command Bytes
    public var commandBytes: [UInt8] {
         return commandString.data(using: .ascii)!.asBytes()
    }
    
    public var bytes:[UInt8] {
        return [controlBytes,commandBytes].reduce([],+)
    }
    
    public var data:Data {
        return Data(bytes)
    }
    
    // Function for Timed Bytes
    public func makeData(_ time:Int) -> Data {
        let command = "\(type.rawValue)&time=\(time)&\(pointString!)"
        let cmdBytes = command.data(using: .ascii)!.asBytes()
        let theBytes:[UInt8] = [controlBytes,cmdBytes].reduce([],+)
        return Data(theBytes)
    }

    
    public init(
        _ type: CommandType,
        _ point: Point?
        )
    {
        self.type = type
        self.point = point
    }
    
    public init(
        _ type: CommandType
        )
    {
        self.type = type
        self.point = nil
    }
}
