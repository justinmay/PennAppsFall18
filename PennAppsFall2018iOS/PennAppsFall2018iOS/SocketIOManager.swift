//
//  SocketIOManager.swift
//  PennAppsFall2018iOS
//
//  Created by Vineeth Puli on 9/9/18.
//  Copyright © 2018 Justin May. All rights reserved.
//


import Foundation
import SocketIO

typealias JSON = [String: Any]

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    var manager : SocketManager = {
        return SocketManager(socketURL: URL(string: "http://24d0ca92.ngrok.io")!, config: [.log(false), .forcePolling(true)])
    }()
    
    override init() {
        super.init()
    }
    
    func setSocketHandler(){
        manager.defaultSocket.on("test") { dataArray, ack in
            let moveDict = (dataArray[0] as! JSON)
            let movez = moveDict["move"] as! String
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: movez), object: nil)
            
            //self.moveReceived(move: movez)
        }
    }
    
    func establishConnection() {
        manager.defaultSocket.connect()
        print("Status: \(manager.defaultSocket.status.description)")
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
}
