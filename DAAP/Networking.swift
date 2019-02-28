import Foundation

extension HTTPURLResponse {
    
    public func logHeaders(){
        print("\n###################\n#####-HEADERS-#####\n--")
        allHeaderFields.forEach({
            print("\(String(describing: $0.key)) : \(String(describing: $0.value))")
        })
        print("Status Code: \(statusCode)")
        print("--\n###################\n")
    }
    
    public func checkHeaders(_ key:String,_ value:String) -> Bool {
        var contains = false
        allHeaderFields.forEach({
            if let headerKey = $0.key as? String {
                if headerKey == key {
                    if let headerValue = $0.value as? String {
                        if headerValue == value {
                            contains = true
                        }
                    }
                }
            }
        })
        return contains
    }
    
    
}
    


//: MARK: - Networking -
//

struct Endpoint {
    static let Base = getBase()
    private static func getBase() -> String {
        return "http://192.168.0.8:8080/"
    }
}


//: MARK: - API Error -
struct APIError {
    let endpoint: String
    let message: String
    let status: Int
    init(_ data:[String:Any]){
        self.endpoint = data["endpoint"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.status = data["status"] as? Int ?? 0
    }
    func toDictionary() -> [String:String] {
        return [
            "Endpoint" : endpoint,
            "Message" : message,
            "Status" : "\(status)"
        ]
    }
}

//: MARK: - CheckedJSON -
public struct CheckedJSON {
    
    public
    var value: [String:Any]
    public
    init(_ data:[String:Any]?){
        if let unwrappedData = data {
            value = unwrappedData
        } else {
            value = [:]
        }
    }
    
    var isUsable: Bool {
        get {
            if let status = value["success"] as? Int {
                if status == 500 {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
    }
    
}


public typealias APICompletionClosure = (CheckedJSON) -> Void

public typealias APIResponseConsumer = (URLResponse,Data) -> Void

//: MARK: - APIRequest -
public struct APIRequest {
    public let endpoint: String
    public let additionalParameters:[String: String]?
    public let data:Data
    public let responseConsumer: APIResponseConsumer
    public let completion: APICompletionClosure
    
   public init(
        _ endpoint:String = "",
        _ additionalParameters:[String: String]? = nil,
        _ completion: @escaping APICompletionClosure = { _ in }
        )
    {
        self.endpoint = endpoint
        self.additionalParameters = additionalParameters
        self.data = Data()
        self.completion = completion
        self.responseConsumer = { _,_ in }
    }
    
    
  public init(
        _ endpoint:String = "",
        _ additionalParameters:[String: String]? = nil,
        _ data:Data = Data(),
        _ responseConsumer: @escaping APIResponseConsumer = { _,_ in }
        )
    {
        self.endpoint = endpoint
        self.additionalParameters = additionalParameters
        self.data = data
        self.responseConsumer = responseConsumer
        self.completion = { _ in }
    }
}

public extension APIRequest {
    
    public func perform() {
        makeAPIRequestWith(self)
    }
    
    public func newWith(_ newResponseConsumer: @escaping APIResponseConsumer = { _,_ in } ) -> APIRequest {
        // login
        let newApiRequest = APIRequest(
            endpoint,
            additionalParameters,
            data
        ) { (response, data) in
            self.responseConsumer(response, data)
            newResponseConsumer(response, data)
        }
        
        return newApiRequest
    }
    
    
}


public extension APIRequest {
    
    public var parameters: [String:String] {
        get {
            var returnParams: [String:String] = [:]
            guard let additionalParams = additionalParameters else { return returnParams }
            for key in additionalParams.keys {
                if let value = additionalParams[key] {
                    returnParams.updateValue(value, forKey: key)
                }
            }
            return returnParams
        }
    }
    
    public var atvGETRequest: URLRequest {
        get {
            var request = URLRequest(url:URL(string: DAAPConst.atvIP+endpoint)!)
            request.httpMethod = "GET"
            request.setValue("*/*", forHTTPHeaderField: "Accept")
            request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
            request.setValue("3.12", forHTTPHeaderField: "Client-DAAP-Version")
            request.setValue("1.2", forHTTPHeaderField: "Client-ATV-Sharing-Version")
            request.setValue("3.10", forHTTPHeaderField: "Client-iTunes-Sharing-Version")
            request.setValue("TVRemote/186 CFNetwork/808.1.4 Darwin/16.1.0", forHTTPHeaderField: "User-Agent")
            request.setValue("1", forHTTPHeaderField: "Viewer-Only-Client")
            request.timeoutInterval = 5.0
            return request
        }
    }
    
    public
    var atvPOSTRequest: URLRequest {
        get {
            var request = URLRequest(url:URL(string: DAAPConst.atvIP+endpoint)!)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "Accept")
            request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("keep-alive", forHTTPHeaderField: "Connection")
            request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
            request.httpBody = data
            return request
        }
    }
    
    public var standardRequest: URLRequest {
        get {
            func makeBodyData(_ params:[String:String]) -> Data {
                let encodedParams = "&"+params.map {"\($0)=\($1)"}.joined(separator: "&")
                return encodedParams.data(using: .utf8, allowLossyConversion: false)!
            }
            let httpBodyData = makeBodyData(parameters)
            
            var request = URLRequest(url:URL(string: Endpoint.Base + endpoint)!)
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("\(httpBodyData.count)", forHTTPHeaderField: "Content-Length")
            request.httpMethod = "POST"
            request.httpBody = httpBodyData
            request.timeoutInterval = 10.0
            return request
        }
    }
    
    public var prefferedRequest: URLRequest {
        get {
            if ["siri","ping","ambi_app","chosen_action"].contains(endpoint) {
                print("Standard Request")
                return standardRequest
            } else {
                if data.count > 0 {
                    print("atvPOST Request")
                    return atvPOSTRequest
                } else {
                    print("atvGET Request")
                    return atvGETRequest
                }
            }
        }
    }
    
    public func log(){
        let log = """
        /~~~~~~~~~~~~~~~~~~~~~~\\
        |  Making Request for:
        |   \(endpoint)
        |  With Params:
        |   \(parameters)
        \\~~~~~~~~~~~~~~~~~~~~~/
        """
        print(log)
    }
    
}


//: MARK: - makeAPIRequest -
public
func makeAPIRequestWith(_ apiRequest:APIRequest) {
    apiRequest.log()
    URLSession.shared.dataTask(with: apiRequest.prefferedRequest) { (data, response, error) in
        
        if error != nil {
            print("URL Session Error: \(String(describing: error))")
            DispatchQueue.main.async(execute: {
                apiRequest.completion(CheckedJSON(["Error":500]))
            })
            return
        }
        
        guard data != nil else {
            DispatchQueue.main.async(execute: {
                apiRequest.completion(CheckedJSON(["No Data":500]))
            })
            return
        }
        
    
        let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        
        guard responseJSON != nil else {
            
            DispatchQueue.main.async(execute: {
                if let d = data, let r = response {
                    apiRequest.responseConsumer(r,d)
                }
            })
            
            DispatchQueue.main.async(execute: {
                apiRequest.completion(CheckedJSON(["success":500]))
            })
            
            return
        }
        
        // Handle Response
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:
                print("Response Code: \(httpResponse.statusCode)")
                DispatchQueue.main.async(execute: {
                    apiRequest.completion(CheckedJSON(responseJSON))
                })
            case 403:
                print("Response Code: \(httpResponse.statusCode) Not Authenticated")
            default:
                print("Response Code: \(httpResponse.statusCode)")
            }
        }
    }.resume()
}
