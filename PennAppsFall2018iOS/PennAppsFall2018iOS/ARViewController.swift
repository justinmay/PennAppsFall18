//
//  ARViewController.swift
//  PennAppsFall2018iOS
//
//  Created by Justin May on 9/7/18.
//  Copyright © 2018 Justin May. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate  {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sceneViewLeft: ARSCNView!
    @IBOutlet weak var sceneViewRight: ARSCNView!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var imageViewLeft: UIImageView!
    
    let eyeCamera : SCNCamera = SCNCamera()
    
    // Parametres
    let interpupilaryDistance = 0.066 // This is the value for the distance between two pupils (in metres). The Interpupilary Distance (IPD).
    let viewBackgroundColor : UIColor = UIColor.black // UIColor.white
    
    /*
     SET eyeFOV and cameraImageScale. UNCOMMENT any of the below lines to change FOV:
     */
    //    let eyeFOV = 38.5; var cameraImageScale = 1.739; // (FOV: 38.5 ± 2.0) Brute-force estimate based on iPhone7+
    let eyeFOV = 60; var cameraImageScale = 3.478; // Calculation based on iPhone7+ // <- Works ok for cheap mobile headsets. Rough guestimate.
    //    let eyeFOV = 90; var cameraImageScale = 6; // (Scale: 6 ± 1.0) Very Rough Guestimate.
    //    let eyeFOV = 120; var cameraImageScale = 8.756; // Rough Guestimate.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let fire = SCNParticleSystem(named: "Fire", inDirectory: nil)!
        fire.emitterShape = SCNCone(topRadius: 0.5,bottomRadius: 0.5,height: 0.5)
        fire.emissionDuration = 2.0
        fire.particleLifeSpan = 5.0
        //let scene = SCNScene(named: "candle.scn")!
        let scene = SCNScene()
        //scene.addParticleSystem(fire, transform: SCNMatrix4MakeTranslation(0,-1,-10))
        // Set the scene to the view
        sceneView.scene = scene
        
        ////////////////////////////////////////////////////////////////
        // App Setup
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Scene setup
        sceneView.isHidden = true
        self.view.backgroundColor = viewBackgroundColor
        
        ////////////////////////////////////////////////////////////////
        // Set up Left-Eye SceneView
        sceneViewLeft.scene = scene
        sceneViewLeft.showsStatistics = sceneView.showsStatistics
        sceneViewLeft.isPlaying = true
        //sceneViewLeft.transform = sceneViewLeft.transform.rotated(by: CGFloat(M_PI_2))
        
        // Set up Right-Eye SceneView
        sceneViewRight.scene = scene
        sceneViewRight.showsStatistics = sceneView.showsStatistics
        sceneViewRight.isPlaying = true
        //sceneViewRight.transform = sceneViewRight.transform.rotated(by: CGFloat(M_PI_2))
        
        ////////////////////////////////////////////////////////////////
        // Update Camera Image Scale - according to iOS 11.3 (ARKit 1.5)
        if #available(iOS 11.3, *) {
            print("iOS 11.3 or later")
            cameraImageScale = cameraImageScale * 1080.0 / 720.0
        } else {
            print("earlier than iOS 11.3")
        }
        
        ////////////////////////////////////////////////////////////////
        // Create CAMERA
        eyeCamera.zNear = 0.001
        /*
         Note:
         - camera.projectionTransform was not used as it currently prevents the simplistic setting of .fieldOfView . The lack of metal, or lower-level calculations, is likely what is causing mild latency with the camera.
         - .fieldOfView may refer to .yFov or a diagonal-fov.
         - in a STEREOSCOPIC layout on iPhone7+, the fieldOfView of one eye by default, is closer to 38.5°, than the listed default of 60°
         */
        eyeCamera.fieldOfView = CGFloat(eyeFOV)
        
        ////////////////////////////////////////////////////////////////
        // Setup ImageViews - for rendering Camera Image
        self.imageViewLeft.clipsToBounds = true
        self.imageViewLeft.contentMode = UIViewContentMode.center
        self.imageViewLeft.transform = self.imageViewLeft.transform.rotated(by: CGFloat(Double.pi/2))
        self.imageViewRight.clipsToBounds = true
        self.imageViewRight.contentMode = UIViewContentMode.center
        self.imageViewRight.transform = self.imageViewRight.transform.rotated(by: CGFloat(Double.pi/2))
        
        if let cameraNode = self.sceneView.pointOfView {
            
            let distance: Float = 1.0 // Hardcoded depth
            let pos = sceneSpacePosition(inFrontOf: cameraNode, atDistance: distance)
            
            addSphere(position: pos)
            
            //ARHelperMethods.addAnimation(node: self.sceneView.scene.rootNode.childNodes[3])
            ARHelperMethods.addAnimation(node: self.sceneView.scene.rootNode.childNodes[3],position: getUserDirection())
        }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapScreen))
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    @objc func didTapScreen(recognizer: UITapGestureRecognizer) {
            if let camera = sceneView.session.currentFrame?.camera {
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -1.0
                let transform = camera.transform * translation
                let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                addWaterBall(position: position)
                ARHelperMethods.addAnimation(node: ARHelperMethods.getLastElement(), position: getUserDirection())
            }
    }
    
    //returns a SCNMatrix4 of the position
    func sceneSpacePosition(inFrontOf node: SCNNode, atDistance distance: Float) -> SCNVector3 {
        let localPosition = SCNVector3(x: 0, y: 0, z: -distance)
        let scenePosition = node.convertPosition(localPosition, to: nil)
        // to: nil is automatically scene space
        return scenePosition
    }
    func addWaterBall(position: SCNVector3){
        let water = SCNParticleSystem(named: "Water", inDirectory: nil)!
        water.emissionDuration = 2.0
        water.particleLifeSpan = 2.0
        
        water.acceleration = getUserDirection()
        
        print("adding sphere at point: \(position)")
        let sphere: WaterBall = WaterBall(position: position)
        sphere.addParticleSystem(water)
        self.sceneView.scene.rootNode.addChildNode(sphere)
        ARHelperMethods.list.append(sphere)
        
    }
    
    func getUserDirection() -> (SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space

            return (dir)
        }
        return (SCNVector3(0, 0, -1))
    }
    
    func addSphere(position: SCNVector3){
        print("adding sphere at point: \(position)")
        let sphere: Sphere = Sphere(position: position)
        let fire = SCNParticleSystem(named: "Fire", inDirectory: nil)!
        fire.emitterShape = SCNCone(topRadius: 0.1,bottomRadius: 0.1,height: 0.1)
        fire.emissionDuration = 2.0
        fire.particleLifeSpan = 2.0
        fire.stretchFactor = 2.0
        fire.acceleration = SCNVector3(0,0,1.0)
        //fire.dampingFactor = 1.0
        //fire.isAffectedByGravity = true
        sphere.addParticleSystem(fire)
        self.sceneView.scene.rootNode.addChildNode(sphere)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFrame()
        }
    }
    
    func updateFrame() {
        /////////////////////////////////////////////
        // CREATE POINT OF VIEWS
        let pointOfView : SCNNode = SCNNode()
        pointOfView.transform = (sceneView.pointOfView?.transform)!
        pointOfView.scale = (sceneView.pointOfView?.scale)!
        // Create POV from Camera
        pointOfView.camera = eyeCamera
        
        // Set PointOfView for SceneView-LeftEye
        sceneViewLeft.pointOfView = pointOfView
        
        // Clone pointOfView for Right-Eye SceneView
        let pointOfView2 : SCNNode = (sceneViewLeft.pointOfView?.clone())!
        // Determine Adjusted Position for Right Eye
        let orientation : SCNQuaternion = pointOfView.orientation
        let orientationQuaternion : GLKQuaternion = GLKQuaternionMake(orientation.x, orientation.y, orientation.z, orientation.w)
        let eyePos : GLKVector3 = GLKVector3Make(1.0, 0.0, 0.0)
        let rotatedEyePos : GLKVector3 = GLKQuaternionRotateVector3(orientationQuaternion, eyePos)
        let rotatedEyePosSCNV : SCNVector3 = SCNVector3Make(rotatedEyePos.x, rotatedEyePos.y, rotatedEyePos.z)
        let mag : Float = Float(interpupilaryDistance)
        pointOfView2.position.x += rotatedEyePosSCNV.x * mag
        pointOfView2.position.y += rotatedEyePosSCNV.y * mag
        pointOfView2.position.z += rotatedEyePosSCNV.z * mag
        
        // Set PointOfView for SceneView-RightEye
        sceneViewRight.pointOfView = pointOfView2
        
        ////////////////////////////////////////////
        // RENDER CAMERA IMAGE
        /*
         Note:
         - as camera.contentsTransform doesn't appear to affect the camera-image at the current time, we are re-rendering the image.
         - for performance, this should ideally be ported to metal
         */
        // Clear Original Camera-Image
        sceneViewLeft.scene.background.contents = UIColor.clear // This sets a transparent scene bg for all sceneViews - as they're all rendering the same scene.
        
        // Read Camera-Image
        let pixelBuffer : CVPixelBuffer? = sceneView.session.currentFrame?.capturedImage
        if pixelBuffer == nil { return }
        let ciimage = CIImage(cvPixelBuffer: pixelBuffer!)
        // Convert ciimage to cgimage, so uiimage can affect its orientation
        let context = CIContext(options: nil)
        let cgimage = context.createCGImage(ciimage, from: ciimage.extent)
        
        // Determine Camera-Image Scale
        var scale_custom : CGFloat = 1.0
        // let cameraImageSize : CGSize = CGSize(width: ciimage.extent.width, height: ciimage.extent.height) // 1280 x 720 on iPhone 7+
        // let eyeViewSize : CGSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height) // (736/2) x 414 on iPhone 7+
        // let scale_aspectFill : CGFloat = cameraImageSize.height / eyeViewSize.height // 1.739 // fov = ~38.5 (guestimate on iPhone7+)
        // let scale_aspectFit : CGFloat = cameraImageSize.width / eyeViewSize.width // 3.478 // fov = ~60
        // scale_custom = 8.756 // (8.756) ~ appears close to 120° FOV - (guestimate on iPhone7+)
        // scale_custom = 6 // (6±1) ~ appears close-ish to 90° FOV - (guestimate on iPhone7+)
        scale_custom = CGFloat(cameraImageScale)
        
        // Determine Camera-Image Orientation
        let imageOrientation : UIImageOrientation = (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft) ? UIImageOrientation.down : UIImageOrientation.up
        
        // Display Camera-Image
        let uiimage = UIImage(cgImage: cgimage!, scale: scale_custom, orientation: imageOrientation)
        self.imageViewLeft.image = uiimage
        self.imageViewRight.image = uiimage
    }
}
