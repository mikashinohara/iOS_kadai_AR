//
//  ViewController.swift
//  iOS_kadai_AR
//
//  Created by 篠原未花 on 2019/05/19.
//  Copyright © 2019 mika shinohara. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    //CGpoint
    var penLocation: CGPoint = .zero
    var isTouching = false
    var existentNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        penLocation = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        penLocation = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }
    
    func createBallNode()-> SCNNode {
        let ball = SCNSphere(radius: 0.005) //太さ調整
        ball.firstMaterial?.diffuse.contents = UIColor.yellow // カラー調整
        return SCNNode(geometry: ball)
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard isTouching else {
            return
        }
        
        let ballNode: SCNNode
        
        //既にノードが作成したら、clone()でコピーして再利用する
        if let node = existentNode {
            ballNode = node.clone()
        } else {
            ballNode = createBallNode()
            existentNode = ballNode
        }
        
        //スクリーン座標から、ワールド座標に変換する
        let wordPostion = sceneView.unprojectPoint(SCNVector3(penLocation.x, penLocation.y, 0.995)) //x,y軸を設定する
        
        ballNode.position = wordPostion
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
}


    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

