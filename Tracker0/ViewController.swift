//
//  ViewController.swift
//  Tracker0
//
//  Created by Vladimir Cezar on 2021-02-15.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/card.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let arReferenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.trackingImages = arReferenceImages
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARImageAnchor else { return }
    
    guard let card = sceneView.scene.rootNode.childNode(withName: "card", recursively: false) else { return }
    card.removeFromParentNode()
    node.addChildNode(card)
    
    card.isHidden = false
    
    let videoURL = Bundle.main.url(forResource: "pirate", withExtension: "mp4")!
    let videoPlayer = AVPlayer(url: videoURL)
    
    let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))
    
    let videoNode = SKVideoNode(avPlayer: videoPlayer)
    videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
    videoNode.size = videoScene.size
    videoNode.yScale = -1
    videoNode.zRotation = 90
    videoNode.play()
    
    videoScene.addChild(videoNode)
    
    guard let video = card.childNode(withName: "video", recursively: true) else { return }
    video.geometry?.firstMaterial?.diffuse.contents = videoScene
    
  }
}
