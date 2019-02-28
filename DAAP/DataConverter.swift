import Foundation

//: MARK: - DataConverter -
public struct DataConverter {
    
    public typealias Bytes = [UInt8]
    // Decimal to Binary
    public static
        func decimalToBinary(_ decimal:UInt8) -> String {
        return String(decimal, radix: 2)
    }
    
    // Binary to decimal
    public static
        func binaryToDecimal(_ binaryString:String) -> Int {
        return Int(binaryString, radix: 2)!
    }
    
    // Decimal to Hex
    public static
        func decimalToHex(_ decimal:UInt8) -> String {
        return String(decimal, radix: 16)
    }
    
    // Hex to Decimal
    public static
        func hexToDecimal(_ hex:String) -> Int {
        return Int(hex, radix: 16)!
    }
    
    // Binary to Hex
    public static
        func binaryToHex(_ binaryString:String) -> String {
        return String(Int(binaryString, radix: 2)!, radix: 16)
    }
    
    // Hex to Binary
    public static
        func hexToBinary(_ hex:String) -> String {
        return String(Int(hex, radix: 16)!, radix: 2)
    }
    
    // Hex to Byte Array (Bytes)
    public static
        func hexToBytes(_ hex: String) -> Bytes {
        var position = hex.startIndex
        return (0..<hex.count/2).compactMap { _ in
            defer { position = hex.index(position, offsetBy: 2) }
            return UInt8(hex[position...hex.index(after: position)], radix: 16)
        }
    }
    
    public static
        func bytesToHex(_ bytes:Bytes) -> String {
        return bytes.map({decimalToHex($0)}).joined()
    }
    
    public static
        func bytesToAscii(_ bytes:Bytes) -> String {
        return bytes.map({"\(UnicodeScalar($0))"}).joined()
    }
    
    
    // ASCII to Text
    public static
        func hexToAsciiText(_ hex:String) -> String {
        return hexToBytes(hex).map({"\(UnicodeScalar($0))"}).joined()
    }
    
    // Read 4 bytes to a Big Endian unsigned number
    public static
        func readQuadBytes(_ bytes:[UInt8]) -> UInt32 {
        return UInt32(bigEndian: Data(bytes: bytes).withUnsafeBytes { $0.pointee })
    }
    
    public static
        func convert(_ data:UInt8) {
        print("-----------------------")
        print("Decimal: \"\(data)\"")
        print("Binary:  \"\(decimalToBinary(data))\"")
        print("Hex:     \"\(decimalToHex(data))\"")
        print("ASCII:   \"\(hexToAsciiText(decimalToHex(data)))\"")
        print("-----------------------")
    }
    
    
    public static
        func decodeChunk(_ data:[UInt8],_ startOffset:Int = 0,_ endIncrement:Int = 4) -> UInt32 {
        var bytes: [UInt8] = []
        var position = data.index(data.startIndex, offsetBy: startOffset)
        
        func append(_ max:Int = 1){
            var count = 0
            while count < max {
                bytes.append(data[position])
                position = data.index(position, offsetBy: 1)
                count += 1
            }
        }
        append(endIncrement)
        return UInt32(bigEndian: Data(bytes: bytes).withUnsafeBytes { $0.pointee })
    }
    
    public static
        func decodeWord(_ data:[UInt8],_ startOffset:Int = 0,_ endIncrement:Int = 4) -> String {
        
        var bytes: [UInt8] = []
        var position = data.index(data.startIndex, offsetBy: startOffset)
        
        func append(_ max:Int = 1){
            var count = 0
            while count < max {
                if count <= data.count-1 {
                    bytes.append(data[position])
                    position = data.index(position, offsetBy: 1)
                    count += 1
                }
                
            }
        }
        
        append(endIncrement)
        
        let dataHex = bytes.map({ DataConverter.decimalToHex($0) }).joined()
        return DataConverter.hexToAsciiText(dataHex)
        
    }
    
}
