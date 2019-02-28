import Foundation

//: MARK: - Tag -
public
struct Tag {
    public let word: String
    public let length: Int
    public let bytes: [UInt8]
    public let valueType: DMAP.DataType
    
    public init(word: String,length: Int,bytes: [UInt8],valueType: DMAP.DataType){
        self.word = word
        self.length = length
        self.bytes = bytes
        self.valueType = valueType
    }
    
    public func deriveData() -> String {
        switch valueType {
        case .dict:
            return "Dictionary: \(bytes))"
        case .data:
            return String(describing: Data(bytes: bytes))
        case .vers:
            return "\(bytes[0]).\(bytes[1]).\(bytes[2]).\(bytes[3])"
        case .int:
            return "\(UInt32(bigEndian: Data(bytes: bytes).withUnsafeBytes { $0.pointee }))"
        case .uint:
            switch bytes.count {
            case 1:
                return "\(bytes[0])"
            case 2:
                return "\(UInt16(bigEndian: Data(bytes: bytes).withUnsafeBytes { $0.pointee }))"
            case 4:
                return "\(UInt32(bigEndian: Data(bytes: bytes).withUnsafeBytes { $0.pointee }))"
            case 8:
                return "\(UInt64(bigEndian: Data(bytes: bytes).withUnsafeBytes { $0.pointee }))"
            default:
                return "\(bytes)"
            }
        case .date:
            return Tag.getDateStringFromBytes(bytes)
        case .str:
            return DataConverter.bytesToAscii(bytes)
        case .unknown:
            return "Unknown: \(DataConverter.bytesToAscii(bytes))"
        }
    }
    
    public static func getDateStringFromBytes(_ data:[UInt8]) -> String {
        let timeInterval = TimeInterval(UInt32(bigEndian: Data(bytes: data).withUnsafeBytes { $0.pointee }))
        print("Time Interval: \(timeInterval)")
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy h:mm:ss a"
        return df.string(from: Date(timeIntervalSince1970:timeInterval))
    }
    
    public func typeString() -> String {
        switch valueType {
        case .dict:
            return "Dictionary"
        case .data:
            return "Data"
        case .vers:
            return "Version"
        case .int:
            return "Int"
        case .uint:
            return "UInt"
        case .date:
            return "Date"
        case .str:
            return "String"
        case .unknown:
            return "Unknown"
        }
    }
    
    public func printTag() {
        print("""
            
            /----TAG----\\
            
             Word: \(word)
             Name: \(findName(word))
             Length: \(length)
             Type: \(typeString())
            -------------
             Bytes: \(bytes.count)
             Data: \(deriveData())
            
            \\___________/
            
            """)
    }
    
}
