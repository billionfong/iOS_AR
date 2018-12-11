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
        
        let scene_buttons = SCNScene(named: "art.scnassets/buttons.scn")!
        let node_L_Y90_Y1 = scene_buttons.rootNode.childNode(withName: "L_Y90_Y1", recursively: false)!
        let node_LM_X90Z90_Z1 = scene_buttons.rootNode.childNode(withName: "LM_X90Z90_Z1", recursively: false)!
        let node_M_X90Z90_Y1 = scene_buttons.rootNode.childNode(withName: "M_X90Z90_Y1", recursively: false)!
        let node_RM_X90Z90_X1 = scene_buttons.rootNode.childNode(withName: "RM_X90Z90_X1", recursively: false)!
        let node_R_Y90_Z1 = scene_buttons.rootNode.childNode(withName: "R_Y90_Z1", recursively: false)!
        node_L_Y90_Y1.position = SCNVector3Make(-0.012, -0.025, -0.05)
        node_LM_X90Z90_Z1.position = SCNVector3Make(-0.006, -0.025, -0.05)
        node_M_X90Z90_Y1.position = SCNVector3Make(0, -0.025, -0.05)
        node_RM_X90Z90_X1.position = SCNVector3Make(0.006, -0.025, -0.05)
        node_R_Y90_Z1.position = SCNVector3Make(0.012, -0.025, -0.05)
        sceneView.pointOfView?.addChildNode(node_L_Y90_Y1)
        sceneView.pointOfView?.addChildNode(node_LM_X90Z90_Z1)
        sceneView.pointOfView?.addChildNode(node_M_X90Z90_Y1)
        sceneView.pointOfView?.addChildNode(node_RM_X90Z90_X1)
        sceneView.pointOfView?.addChildNode(node_R_Y90_Z1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer)
    {
        let touchLocation: CGPoint = sender.location(in: sender.view)
        let scene_ARHead = SCNScene(named: "art.scnassets/ARHead.scn")!
        
        // 5.8 cm for width
        // 0.4 cm for left right margin
        // 1.0 cm for each coins
        // 25.8 units = 0.4
        // 64.7 units = 1.0
        
        // 10.4 cm for height
        // 8.9 cm for top margin
        // 1.0 cm for coin
        // 570.8 units = 8.9
        // 66.1 units = 1.0
        
        if (90.5>touchLocation.x && touchLocation.x>25.8 && 637>touchLocation.y && touchLocation.y>571) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "L_X270Z90_Z1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        } else if (155.2>touchLocation.x && touchLocation.x>90.5 && 637>touchLocation.y && touchLocation.y>571) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "LM_Y90_Y1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        } else if (219.9>touchLocation.x && touchLocation.x>155.2 && 637>touchLocation.y && touchLocation.y>571) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "M_Y90_Z1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        } else if (284.6>touchLocation.x && touchLocation.x>219.9 && 637>touchLocation.y && touchLocation.y>571) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "RM_Y90_X1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        } else if (349.3>touchLocation.x && touchLocation.x>284.6 && 637>touchLocation.y && touchLocation.y>571) {
            for anchor in (sceneView.session.currentFrame?.anchors)! {
                let node_old = sceneView.node(for: anchor)?.childNodes.first
                let node_new = scene_ARHead.rootNode.childNode(withName: "R_Z90_Y1", recursively: false)!
                node_new.position = SCNVector3Make(0, 0.005, 0)
                sceneView.node(for: anchor)?.replaceChildNode(node_old!, with: node_new)
            }
        }
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
}
