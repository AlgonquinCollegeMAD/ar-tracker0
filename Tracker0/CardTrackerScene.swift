import SwiftUI
import SceneKit
import ARKit

struct CardTrackerScene: UIViewRepresentable {
  class Coordinator: NSObject, ARSCNViewDelegate {
    var parent: CardTrackerScene
    
    init(parent: CardTrackerScene) {
      self.parent = parent
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
      guard anchor is ARImageAnchor else { return }
      
      guard let card = parent.sceneView.scene.rootNode.childNode(withName: "card", recursively: false) else { return }
      card.removeFromParentNode()
      node.addChildNode(card)
      
      card.isHidden = false
      
      let videoURL = Bundle.main.url(forResource: "thetruth", withExtension: "mp4")!
      let videoPlayer = AVPlayer(url: videoURL)
      
      let videoScene = SKScene(size: CGSize(width: 720, height: 1280))
      
      let videoNode = SKVideoNode(avPlayer: videoPlayer)
      videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
      videoNode.size = videoScene.size
      videoNode.zRotation = .pi
//      videoNode.xScale = -1
      videoNode.play()
      
      videoScene.addChild(videoNode)
      
      guard let video = card.childNode(withName: "video", recursively: true) else { return }
      video.geometry?.firstMaterial?.diffuse.contents = videoScene
    }
  }
  
  var sceneView = ARSCNView()
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  func makeUIView(context: Context) -> ARSCNView {
    sceneView.delegate = context.coordinator
    
    let scene = SCNScene(named: "art.scnassets/card.scn")!
    sceneView.scene = scene
    
    let configuration = ARImageTrackingConfiguration()
    guard let arReferenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return sceneView }
    configuration.trackingImages = arReferenceImages
    sceneView.session.run(configuration)
    
    return sceneView
  }
  
  func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
