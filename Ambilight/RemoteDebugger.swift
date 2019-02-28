//
//  RemoteDebugger.swift
//  Ambilight
//
//  Created by Justin Madewell on 7/18/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import UIKit

struct DebugData<S: Encodable>: Encodable {
    var state: S
    var action: String
    var imageData: Data
}

final class RemoteDebugger: NSObject, NetServiceBrowserDelegate {
    let browser = NetServiceBrowser()
    let queue = DispatchQueue(label: "remoteDebugger")
    var output: OutputStream?
    private let serviceType = "_debug._tcp"
    
    override init() {
        super.init()
        browser.delegate = self
        browser.searchForServices(ofType: serviceType, inDomain: "local")
    }
    
    
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        var input: InputStream?
        service.getInputStream(&input, outputStream: &output)
        CFReadStreamSetDispatchQueue(input, queue)
        CFWriteStreamSetDispatchQueue(output, queue)
    }
    
}
