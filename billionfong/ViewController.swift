//
//  ViewController.swift
//  billionfong
//  Device: iPhone 11, iPad Air 2
//
//  Created by Billionfong on 2/8/2018.
//  Copyright © 2018 Billionfong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ReplayKit

class ViewController: UIViewController, ARSCNViewDelegate, RPPreviewViewControllerDelegate, UIGestureRecognizerDelegate
{
    @IBOutlet var sceneView: ARSCNView!
    
    
    
    // Basic Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sceneView.delegate = self
        
        // Bottom 5 Buttons
        for bottomButton in createBottomButtons() {
            sceneView.pointOfView?.addChildNode(bottomButton)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        sceneView.addGestureRecognizer(tap)
        
        // Camera Button
        cameraButton()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else { return }
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    
    // AR Functions
    func createBottomButtons() -> [SCNNode] {
        let scene_buttons = SCNScene(named: "art.scnassets/buttons.scn")!
        let node_L_Y90_Y1 = scene_buttons.rootNode.childNode(withName: "L_Y90_Y1", recursively: false)!
        let node_LM_X90Z90_Z1 = scene_buttons.rootNode.childNode(withName: "LM_X90Z90_Z1", recursively: false)!
        let node_M_X90Z90_Y1 = scene_buttons.rootNode.childNode(withName: "M_X90Z90_Y1", recursively: false)!
        let node_RM_X90Z90_X1 = scene_buttons.rootNode.childNode(withName: "RM_X90Z90_X1", recursively: false)!
        let node_R_Y90_Z1 = scene_buttons.rootNode.childNode(withName: "R_Y90_Z1", recursively: false)!
        
        var x = Float(1)
        var y = Float(1)
        var z = Float(1)
        
        if (UIDevice().model == "iPhone")
        {
            x = 0.006
            y = -0.028
            z = -0.05
        }
        else if (UIDevice().model == "iPad")
        {
            x = -0.007
            y = -0.023
            z = -0.05
        }
        
        node_L_Y90_Y1.position = SCNVector3Make(-2*x, y, z)
        node_LM_X90Z90_Z1.position = SCNVector3Make(-1*x, y, z)
        node_M_X90Z90_Y1.position = SCNVector3Make(0, y, z)
        node_RM_X90Z90_X1.position = SCNVector3Make(x, y, z)
        node_R_Y90_Z1.position = SCNVector3Make(2*x, y, z)
        
        let buttons = [node_L_Y90_Y1, node_LM_X90Z90_Z1, node_M_X90Z90_Y1, node_RM_X90Z90_X1, node_R_Y90_Z1]
        return buttons
    }
        
    @IBAction func handleTap(sender: UITapGestureRecognizer)
    {
        let touchLocation: CGPoint = sender.location(in: sender.view)

        let screenBounds = UIScreen.main.bounds
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
        var w1 = CGFloat(1)
        var w2 = CGFloat(1)
        var h1 = CGFloat(1)
        var h2 = CGFloat(1)
                
        if (UIDevice().model == "iPhone")
        {
            w1 = CGFloat(screenWidth / 6.5 * 0.2)
            w2 = CGFloat(screenWidth / 6.5 * 1.21)
            h1 = CGFloat(screenHeight / 14 * 12.1)
            h2 = CGFloat(screenHeight / 14 * 1.21)
        }
        else if (UIDevice().model == "iPad")
        {
            w1 = CGFloat(screenWidth / 14.7 * 0.85)
            w2 = CGFloat(screenWidth / 14.7 * 2.6)
            h1 = CGFloat(screenHeight / 19.7 * 17.3)
            h2 = CGFloat(screenHeight / 19.7 * 2.2)
        }
        
        if ((w1+w2)>touchLocation.x && touchLocation.x>(w1) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            replaceAR(nodeNew: "L_X270Z90_Z1")
        } else if ((w1+w2*2)>touchLocation.x && touchLocation.x>(w1+w2) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            replaceAR(nodeNew: "LM_Y90_Y1")
        } else if ((w1+w2*3)>touchLocation.x && touchLocation.x>(w1+w2*2) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            replaceAR(nodeNew: "M_Y90_Z1")
        } else if ((w1+w2*4)>touchLocation.x && touchLocation.x>(w1+w2*3) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            replaceAR(nodeNew: "RM_Y90_X1")
        } else if ((w1+w2*5)>touchLocation.x && touchLocation.x>(w1+w2*4) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            replaceAR(nodeNew: "R_Z90_Y1")
        }
    }
    
    @objc func replaceAR(nodeNew: String){
        let scene_ARHead = SCNScene(named: "art.scnassets/ARHead.scn")!
        for anchor in (sceneView.session.currentFrame?.anchors)! {
            let node_old = sceneView.node(for: anchor)?.childNodes.first
            let node_new = scene_ARHead.rootNode.childNode(withName: nodeNew, recursively: false)!
            node_new.position = SCNVector3Make(0, 0.005, 0)
            sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            UIImageWriteToSavedPhotosAlbum(sceneView.snapshot(), nil, nil, nil)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor
        {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 0, alpha: 0)
            let node_plane = SCNNode(geometry: plane)
            node_plane.eulerAngles.x = -.pi / 2
            let scene_ARHead = SCNScene(named: "art.scnassets/ARHead.scn")!

            let node_init = scene_ARHead.rootNode.childNode(withName: "init", recursively: false)!
            node_init.position = SCNVector3Make(0, 0, 0.005)
            node_plane.addChildNode(node_init)
            node.addChildNode(node_plane)
        }
        return node
    }
    
    
    
    // Camera Button
    func cameraButton() {
        var circlePath = UIBezierPath()
        if (UIDevice().model == "iPhone") {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: 207, y: 745), radius: CGFloat(30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        }
        else if (UIDevice().model == "iPad") {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: 384, y: 855), radius: CGFloat(30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        
        
        var button = UIButton()
        if (UIDevice().model == "iPhone") {
            button = UIButton(frame: CGRect(x: 182, y: 720, width: 50, height: 50))
        }
        else if (UIDevice().model == "iPad") {
            button = UIButton(frame: CGRect(x: 359, y: 830, width: 50, height: 50))
        }
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.tag = 123321
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (screenshot))
        tapGesture.delegate = self
        button.addGestureRecognizer(tapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordButtonTapped))
        longGesture.delegate = self
        button.addGestureRecognizer(longGesture)
        
        
        self.view.layer.addSublayer(shapeLayer)
        self.view.addSubview(button)
    }
    
    @IBAction func screenshot(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.main.scale)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
        
    @IBAction func recordButtonTapped(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.began) {
            RPScreenRecorder.shared().startRecording{(error) in }
            self.view.viewWithTag(123321)?.backgroundColor = .red
        } else if (sender.state == UIGestureRecognizer.State.ended) {
            RPScreenRecorder.shared().stopRecording { [unowned self] (preview, error) in
                guard let preview = preview else { return }
                preview.modalPresentationStyle = .automatic
                preview.previewControllerDelegate = self
                self.present(preview, animated: true, completion: nil)
            }
            self.view.viewWithTag(123321)?.backgroundColor = .white
        }
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
    }
}
