//
//  ATVCommander.swift
//  Ambilight
//
//  Created by Justin Madewell on 7/8/18.
//  Copyright © 2018 Jmade. All rights reserved.
//

import UIKit

public typealias ImageCompletion = (UIImage) -> ()

public struct ATVCommander {
    
    private static let verticalPoints:[Point] = [(20,275),(20,270),(20,265),(20,260),(20,255),(20,250)]
    private static let horizontalPoints:[Point] = [(75,100),(70,100),(65,100),(60,100),(55,100),(50,100)]
    
    public static func select() {
        performCommand(CMBECommand(.select))
    }
    
    public static func menu(){
        performCommand(CMBECommand(.menu))
    }
    
    public static func down(){
        performCommands(makeCommands(verticalPoints.reversed()))
    }
    
    public static func up(){
        performCommands(makeCommands(verticalPoints))
    }
    
    public static func left(){
        performCommands(makeCommands(horizontalPoints))
    }
    
    public static func right(){
        performCommands(makeCommands(horizontalPoints.reversed()))
    }
    
    public static func test(){
        DAAPRequests.newlogin().newWith { (_,data) in
            
            data.asBytes().forEach({DataConverter.convert($0)})
        
            let sessionId = DAAPRequests.findSessionId(data)
            print(" sessionId -> \(sessionId) ")
            
            }.perform()
    }
    
    
    public static func getArtwork(_ completion: @escaping ImageCompletion){
        
        DAAPRequests.login().newWith { (_,data) in
            let sessionId = DAAPRequests.findSessionId(data)
            
            DAAPRequests.fetchNowPlayingImage(sessionId, {
                completion($0)
            })
            
            DAAPRequests.logout(sessionId).perform()
            
            }.perform()
    }
    
}


extension ATVCommander {
    
    private static func makeCommands(_ points:[Point]) -> [CMBECommand] {
        guard !points.isEmpty else { return [] }
        return
            [
                [CMBECommand(.touchDown, points.first)],
                points.map({CMBECommand(.touchMove, $0)}),
                [CMBECommand(.touchUp, points.last)],
            ].reduce([],+)
    }
    
    
    // Wraps a Single Command to be performed around A Login Request and Logout Request.
    private static func performCommand(_ command:CMBECommand) {
        DAAPRequests.login().newWith { (_,data) in
            let sessionId = DAAPRequests.findSessionId(data)
            DAAPRequests.control(sessionId, command.data).perform()
            DAAPRequests.logout(sessionId).perform()
            }.perform()
    }
    
    // Wraps an Array of Commands to be performed around A Login Request and Logout Request.
    private static func performCommands(_ commands:[CMBECommand]) {
        DAAPRequests.login().newWith { (_,data) in
            let sessionId = DAAPRequests.findSessionId(data)
            var datas:[Data] = []
            
            for (i,c) in commands.enumerated() {
                datas.append(c.makeData(i+1))
            }
            
            datas.forEach({ DAAPRequests.control(sessionId, $0).perform() })
            DAAPRequests.logout(sessionId).perform()
            }.perform()
    }
    
}



