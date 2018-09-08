//
//  ARHelperMethods.swift
//  PennAppsFall2018iOS
//
//  Created by Justin May on 9/8/18.
//  Copyright © 2018 Justin May. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class ARHelperMethods{
    class func addAnimation(node: SCNNode) {
        let animateOne = SCNAction.moveBy(x: 0.0, y: 0.0, z: -15.0, duration: 5.0)
        let removeFrom = SCNAction.removeFromParentNode()
        let sequence = SCNAction.sequence([animateOne, removeFrom])
        //let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 10.0)
        //node.runAction(rotateOne)
        node.runAction(sequence)
        
    }
}

