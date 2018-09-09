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
    
    var manager : SocketManager!
    var socket : SocketIOClient!
    
    override init() {
        super.init()
        
        manager = SocketManager(socketURL: URL(string: "http://8285b8ff.ngrok.io")!, config: [.log(false), .forcePolling(true)])
        socket = manager.defaultSocket
        socket.on("test") { dataArray, ack in
            let moveDict = (dataArray[0] as! JSON)
            let movez = moveDict["move"] as! String
            ARViewController.moveReceived(move: movez)
        }
        
    }
    
    func establishConnection() {
        socket.connect()
        print("Status: \(socket.status.description)")
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
