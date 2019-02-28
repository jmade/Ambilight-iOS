//
//  AmbilightOptions.swift
//  Ambilight
//
//  Created by Justin Madewell on 7/3/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import Foundation

struct AmbilightOption {
    
    enum Catagory: String {
        case cec = "CEC"
        case neopixel = "Neopixel"
        case volume = "Volume"
        case atv = "ATV"
        case ir = "IR"
        case test = "TEST"
        case exp = "EXPERIMENTAL"
        case undefined = "-"
        
        func displayValue() -> String {
            switch self {
            case .cec:
                return "CEC"
            case .neopixel:
                return "Neopixel"
            case .volume:
                return "Volume"
            case .atv:
                return "tv"
            case .ir:
                return "IR"
            case .test:
                return "Test"
            case .exp:
                return "Experimental"
            case .undefined:
                return "-"
            }
        }
    }
    
    let catagory: Catagory
    let title: String
    let description: String
    
    enum Keys: String {
        case catagory = "catagory"
        case title = "title"
        case description = "description"
    }
    
    init(_ data:[String:Any] = [:]) {
        let rawCatagoryValue = data[Keys.catagory.rawValue] as? String ?? "-"
        if let catagory = Catagory(rawValue: rawCatagoryValue) {
            self.catagory = catagory
        } else {
            self.catagory = .undefined
        }
        self.title = data[Keys.title.rawValue] as? String ?? ""
        self.description = data[Keys.description.rawValue] as? String ?? ""
    }
    
}

struct AmbilightResponse {
    enum Status {
        case active, inactive, undefined
    }
    
    let options: [AmbilightOption]
    let status: Status
    let processName:String
    
    enum Keys: String {
        case options = "options"
        case light_reading = "light_reading"
    }
    
    init(_ data:[String:Any] = [:]){
        self.options = (data[Keys.options.rawValue] as? [[String:Any]] ?? [[:]]).map({AmbilightOption($0)})
        let lightStatus = (data[Keys.light_reading.rawValue] as? [String:Any] ?? [:])
        self.processName = lightStatus["process"] as? String ?? "-"
        let status = lightStatus["status"] as? String ?? "-"
        
        switch status {
        case "Y":
            self.status = .active
        case "N":
            self.status = .inactive
        default:
            self.status = .undefined
        }
        
        
    }
}



