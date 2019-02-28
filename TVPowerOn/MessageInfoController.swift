import Foundation

struct MessageResponse {
    var serverMessage:String
    
    init(_ json:[String:Any]) {
        self.serverMessage = json["serverMessage"] as? String ?? "-"
    }
}


struct MessageInfoController {
    
    func fetchTVPowerOn(completion: @escaping (MessageResponse?) -> Void) {
        makeRequestFor("siri", completion: completion)
    }

    
    func sendAction(_ action:String,completion: @escaping (MessageResponse?) -> Void) {
        makeActionRequest(action, completion: completion)
    }
    
}

extension MessageInfoController {
    
    private
    func makeRequestFor(_ action:String,completion: @escaping (MessageResponse?) -> Void) {


        func makeBodyData(_ params:[String:String]) -> Data {
            let encodedParams = "&"+params.map {"\($0)=\($1)"}.joined(separator: "&")
            return encodedParams.data(using: .utf8, allowLossyConversion: false)!
        }
        
        let parameters:[String:String] = [
            "action" : action,
        ]
        
        let httpBodyData = makeBodyData(parameters)
        
        var request = URLRequest(url:URL(string: "http://192.168.0.8:8080/siri")!)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(httpBodyData.count)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = httpBodyData
        request.timeoutInterval = 10.0
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(data ?? "-")
            
            guard let data = data else {
                DispatchQueue.main.async(execute: {
                    print("Error No Data")
                    completion(nil)
                })
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                    DispatchQueue.main.async(execute: {
                      completion(MessageResponse(json))
                    })
                    
                }
            } catch let error {
                print("Error Parsing JSON: \(error.localizedDescription)")
                DispatchQueue.main.async(execute: {
                    completion(nil)
                })
            }
        
        }
        
        task.resume()
    }
    
}



extension MessageInfoController {
    
    private
    func makeActionRequest(_ action:String,completion: @escaping (MessageResponse?) -> Void) {
        
        let powerTVOn = "TV Power On"
        let atvMenu = "Menu"
        
        func makeBodyData(_ params:[String:String]) -> Data {
            let encodedParams = "&"+params.map {"\($0)=\($1)"}.joined(separator: "&")
            return encodedParams.data(using: .utf8, allowLossyConversion: false)!
        }
        
        let parameters:[String:String] = [
            "action" : action,
            ]
        
        let httpBodyData = makeBodyData(parameters)
        
        var request = URLRequest(url:URL(string: "http://192.168.0.8:8080/siri")!)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(httpBodyData.count)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = httpBodyData
        request.timeoutInterval = 10.0
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(data ?? "-")
            
            guard let data = data else {
                DispatchQueue.main.async(execute: {
                    print("Error No Data")
                    completion(nil)
                })
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                    DispatchQueue.main.async(execute: {
                        completion(MessageResponse(json))
                    })
                    
                }
            } catch let error {
                print("Error Parsing JSON: \(error.localizedDescription)")
                DispatchQueue.main.async(execute: {
                    completion(nil)
                })
            }
            
        }
        
        task.resume()
    }
    
}



