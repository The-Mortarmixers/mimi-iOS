//
//  TileARViewController.swift
//  mimi. iOS
//
//  Created by Josef Büttgen on 07.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class TileARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var continueButton: BigButton!
    @IBOutlet weak var sceneView: ARSCNView!
    
    private var planeAnchor: ARAnchor?
    private var planeNode: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard self.planeAnchor == nil else { return }
        
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        self.planeAnchor = planeAnchor
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor(hue: 208/255, saturation: 100/255, brightness: 98/255, alpha: 0.5)
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        self.planeNode = planeNode
        
        // 6
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    
    @IBAction func setTileWallButtonPushed(_ sender: Any) {
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = UIImage(named: "tile1.png")
        imageMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(5, 5, 0)
        
        planeNode?.geometry?.firstMaterial = imageMaterial
        
        planeNode?.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
        planeNode?.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat

        continueButton.setTitle("Proceed with 48 Tiles", for: .normal)
        
    }
    
    @IBAction func clearButtonPushed(_ sender: Any) {
        self.planeNode?.removeFromParentNode()
        self.planeNode = nil
        self.planeAnchor = nil
    }
}
