import Foundation

public extension Data {
    
    public func copyBytes<T>(as _: T.Type) -> [T] {
        return withUnsafeBytes { (bytes: UnsafePointer<T>) in
            Array(UnsafeBufferPointer(start: bytes, count: count / MemoryLayout<T>.stride))
        }
    }
    
    public func asBytes() -> [UInt8] {
        return withUnsafeBytes {
            UnsafeBufferPointer<UInt8>(
                start: $0,
                count: self.count / MemoryLayout<UInt8>.stride
                )
                .map(UInt8.init(littleEndian:))
        }
    }
    
}


