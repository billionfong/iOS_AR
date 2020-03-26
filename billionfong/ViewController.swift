//
//  ViewController.swift
//  billionfong
//
//  Created by Billionfong on 2/8/2018.
//  Copyright © 2018 Billionfong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate
{
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sceneView.delegate = self
        
        // Bottom 5 Buttons
        for bottomButton in createBottomButtons() {
            sceneView.pointOfView?.addChildNode(bottomButton)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
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
        
    func createBottomButtons() -> [SCNNode] {
        let scene_buttons = SCNScene(named: "art.scnassets/buttons.scn")!
        let node_L_Y90_Y1 = scene_buttons.rootNode.childNode(withName: "L_Y90_Y1", recursively: false)!
        let node_LM_X90Z90_Z1 = scene_buttons.rootNode.childNode(withName: "LM_X90Z90_Z1", recursively: false)!
        let node_M_X90Z90_Y1 = scene_buttons.rootNode.childNode(withName: "M_X90Z90_Y1", recursively: false)!
        let node_RM_X90Z90_X1 = scene_buttons.rootNode.childNode(withName: "RM_X90Z90_X1", recursively: false)!
        let node_R_Y90_Z1 = scene_buttons.rootNode.childNode(withName: "R_Y90_Z1", recursively: false)!
        
        if (UIScreen.main.bounds.width == 375) //iPhone 7
        {
            node_L_Y90_Y1.position = SCNVector3Make(-0.012, -0.025, -0.05)
            node_LM_X90Z90_Z1.position = SCNVector3Make(-0.006, -0.025, -0.05)
            node_M_X90Z90_Y1.position = SCNVector3Make(0, -0.025, -0.05)
            node_RM_X90Z90_X1.position = SCNVector3Make(0.006, -0.025, -0.05)
            node_R_Y90_Z1.position = SCNVector3Make(0.012, -0.025, -0.05)
        }
        else if (UIScreen.main.bounds.width == 414) // iPhone 11
        {
            node_L_Y90_Y1.position = SCNVector3Make(-0.012, -0.028, -0.051)
            node_LM_X90Z90_Z1.position = SCNVector3Make(-0.006, -0.028, -0.051)
            node_M_X90Z90_Y1.position = SCNVector3Make(0, -0.028, -0.051)
            node_RM_X90Z90_X1.position = SCNVector3Make(0.006, -0.028, -0.051)
            node_R_Y90_Z1.position = SCNVector3Make(0.012, -0.028, -0.051)
        }
        else // iPad Air 2
        {
            node_L_Y90_Y1.position = SCNVector3Make(-0.012, -0.02, -0.05)
            node_LM_X90Z90_Z1.position = SCNVector3Make(-0.006, -0.02, -0.05)
            node_M_X90Z90_Y1.position = SCNVector3Make(0, -0.02, -0.05)
            node_RM_X90Z90_X1.position = SCNVector3Make(0.006, -0.02, -0.05)
            node_R_Y90_Z1.position = SCNVector3Make(0.012, -0.02, -0.05)
        }
        
        let buttons = [node_L_Y90_Y1, node_LM_X90Z90_Z1, node_M_X90Z90_Y1, node_RM_X90Z90_X1, node_R_Y90_Z1]
        return buttons
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer)
    {
        let touchLocation: CGPoint = sender.location(in: sender.view)
        let scene_ARHead = SCNScene(named: "art.scnassets/ARHead.scn")!
        
        
        let screenBounds = UIScreen.main.bounds
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
        var w1 = CGFloat(1)
        var w2 = CGFloat(1)
        var h1 = CGFloat(1)
        var h2 = CGFloat(1)
        
        // iPhone 7
        // 1.0  coins size
        // 5.8  width
        // 0.4  left right margin
        // 10.4 height
        // 8.9  from top
        
        // iPhone 11
        // 1.21 coins size
        // 6.5  width
        // 0.2  left right margin
        // 14   height
        // 12.1 from top
        
        
        // iPad
        // 2.1  coin size
        // 14.7 width
        // 2.1  left right margin
        // 19.7 height
        // 16.5 from top
        
        if (screenWidth == 375)
        {
            w1 = CGFloat(screenWidth / 5.8 * 0.4)
            w2 = CGFloat(screenWidth / 5.8 * 1.0)
            h1 = CGFloat(screenHeight / 10.4 * 8.9)
            h2 = CGFloat(screenHeight / 10.4 * 1.0)
        }
        else if (screenWidth == 414)
        {
            w1 = CGFloat(screenWidth / 6.5 * 0.2)
            w2 = CGFloat(screenWidth / 6.5 * 1.21)
            h1 = CGFloat(screenHeight / 14 * 12.1)
            h2 = CGFloat(screenHeight / 14 * 1.21)
        }
        else
        {
            w1 = CGFloat(screenWidth / 14.7 * 2.1)
            w2 = CGFloat(screenWidth / 14.7 * 2.1)
            h1 = CGFloat(screenHeight / 19.7 * 16.5)
            h2 = CGFloat(screenHeight / 19.7 * 2.1)
        }
        
        if ((w1+w2)>touchLocation.x && touchLocation.x>(w1) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "L_X270Z90_Z1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
                UIImageWriteToSavedPhotosAlbum(sceneView.snapshot(), nil, nil, nil)
            }
        } else if ((w1+w2*2)>touchLocation.x && touchLocation.x>(w1+w2) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "LM_Y90_Y1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        } else if ((w1+w2*3)>touchLocation.x && touchLocation.x>(w1+w2*2) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "M_Y90_Z1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        } else if ((w1+w2*4)>touchLocation.x && touchLocation.x>(w1+w2*3) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "RM_Y90_X1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        } else if ((w1+w2*5)>touchLocation.x && touchLocation.x>(w1+w2*4) && (h1+h2)>touchLocation.y && touchLocation.y>(h1)) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "R_Z90_Y1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        }
    }
    
    func cameraButton() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 207, y: 745), radius: CGFloat(30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        self.view.layer.addSublayer(shapeLayer)
        
        let button = UIButton(frame: CGRect(x: 182, y: 720, width: 50, height: 50))
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(screenshot), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @IBAction func screenshot(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.main.scale)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
}
