//  Sphere.swift

import Foundation
import ARKit

class WaterBall: SCNNode {
    
    static let radius: CGFloat = 0.01
    
    let sphereGeometry: SCNSphere
    
    // Required but unused
    required init?(coder aDecoder: NSCoder) {
        sphereGeometry = SCNSphere(radius: Sphere.radius)
        super.init(coder: aDecoder)
    }
    
    // The real action happens here
    init(position: SCNVector3) {
        self.sphereGeometry = SCNSphere(radius: Sphere.radius)
        
        super.init()
        
        let sphereNode = SCNNode(geometry: self.sphereGeometry)
        sphereNode.position = position
        
        self.addChildNode(sphereNode)
    }
    
    func clear() {
        self.removeFromParentNode()
    }
    
}
