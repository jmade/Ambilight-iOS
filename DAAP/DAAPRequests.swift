import UIKit

//: MARK: - TagConsumer -
public typealias TagConsumer = ([Tag]) -> ()
public typealias ImageProducer = (UIImage) -> ()

//: MARK: - DAAPRequests -
public struct DAAPRequests {

    //: MARK: - Login ID -
    public static let LOGIN_ID = DAAPConst.paringID
    public static let ATV_SN = DAAPConst.atvSN
    
    static func fetchNowPlayingImage(_ sessionId:Int,_ imageProducer: @escaping ImageProducer) {
        
        let albumArtwork: APIResponseConsumer = { (response,data) in
            if let httpResponse = response as? HTTPURLResponse {
                httpResponse.logHeaders()
                if httpResponse.checkHeaders("Content-Type", "image/png") {
                    if let image = UIImage(data: data) {
                        print("Got an Image!")
                        imageProducer(image)
                    }
                }
            }
        }
        
        APIRequest(
            "ctrl-int/1/nowplayingartwork?mw=1024&mh=576&session-id=\(sessionId)",
            nil,
            Data(),
            albumArtwork
        ).perform()
    }
    
    // Now Playing Artwork
    static func nowPlayingArtwork(_ sessionId:Int) -> APIRequest {
        
        let albumArtwork: APIResponseConsumer = { (response,data) in
            
            if let httpResponse = response as? HTTPURLResponse {
                httpResponse.logHeaders()
                if httpResponse.checkHeaders("Content-Type", "image/png") {
                    if let image = UIImage(data: data) {
                        print("Got an Image!")
                        let _ = image
                    }
                }
            }
            
        }
        
        return .init(
            "ctrl-int/1/nowplayingartwork?mw=1024&mh=576&session-id=\(sessionId)",
            nil,
            Data(),
            albumArtwork
        )
    }
    
    
    // ServerInfo
    public static func serverInfo() -> APIRequest {
        return .init(
            "server-info",
            nil,
            Data(),
            makeConsumer(false)
        )
    }
    
    // Login
    public static func login(_ loginGuid:String = LOGIN_ID) -> APIRequest {
        return .init(
            "login?pairing-guid=\(loginGuid)",
            nil,
            Data(),
            makeConsumer(false)
        )
    }
    
    // Login
    public static func newlogin() -> APIRequest {
        return .init(
            "?pairing-guid=\(ATV_SN)",
            nil,
            Data(),
            makeConsumer(true)
        )
    }
    
    // Logout
    public static func logout(_ sessionId:Int) -> APIRequest {
        return .init(
            "logout?session-id=\(sessionId)",
            nil,
            Data(),
            makeConsumer(false)
        )
    }
    
    
    // Content Codes
    public static func contentCodes() -> APIRequest {
        return .init(
            "content-codes",
            nil,
            Data(),
            makeConsumer(false)
        )
    }
    
    // Control Prompt Entry
    public static func control(_ sessionId:Int,_ data:Data = Data()) -> APIRequest {
        return .init(
            "ctrl-int/1/controlpromptentry?prompt-id=114&session-id=\(sessionId)",
            nil,
            data,
            makeConsumer(false)
        )
        
    }
    
    //: MARK: - Decoding Tags -
    public static func decodeDMAPTags(_ data:[UInt8]) -> [Tag] {
        
        var tags: [Tag] = []
        var index = 0
        
        func findTag(){
            
            let word = DataConverter.decodeWord(data, index, 4)
            index += 4
            
            let length = Int(DataConverter.decodeChunk(data, index, 4))
            index += 4
            
            let bytes = Array(data[index..<(index + length)])
            index += length
            
            let tag = Tag(word: word, length: length, bytes: bytes, valueType: findValue(word))
            
            // Add Tag
            tags.append(tag)
            if tag.valueType == .dict {
                index -= length
            }
            
        }
        
        while index < data.count-1 {
            findTag()
        }
        
        return tags
    }
    
    
    // Session Id from (Data)
    public static func findSessionId(_ data:Data) -> Int {
        var sessionId = 0
        let tags = DAAPRequests.decodeDMAPTags(data.withUnsafeBytes {
            UnsafeBufferPointer<UInt8>(
                start: $0,
                count: data.count / MemoryLayout<UInt8>.stride
                ).map(UInt8.init(littleEndian:))
        })
        
        if let tag = tags.filter({ $0.word == "mlid" }).first {
            if let id = Int(tag.deriveData()) {
                sessionId = id
                print("Session ID: \(sessionId)")
            }
        }
        
        return sessionId
    }
    
    //: MARK: - makeConsumer -
    public static func makeConsumer(_ shouldPrint:Bool = true,_ tagConsumer: @escaping TagConsumer = {_ in}) -> APIResponseConsumer {
        return { (response,data) in
            
            if shouldPrint {
                if let r = response as? HTTPURLResponse { r.logHeaders() }
            }
            
            let tags = decodeDMAPTags(data.asBytes())
            
            if shouldPrint {
                tags.forEach({$0.printTag()})
            }
            
            tagConsumer(tags)
        }
    }
    
}
