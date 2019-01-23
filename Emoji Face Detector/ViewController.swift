//  ViewController.swift
//  Emoji Face Detector

//  Created by George Garcia on 1/23/19.
//  Copyright © 2019 George Garcia. All rights reserved.


import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    let sceneView = ARSCNView()
    let smileLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking not supported from this device!")
        }
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
            
            if (granted) {
                DispatchQueue.main.sync {
                    self.setupFaceTracking()
                }
            } else {
                fatalError("User did not grand permission for camera usage")
            }
        })
    }
    
    func setupFaceTracking() {
        let config = ARFaceTrackingConfiguration()
        sceneView.session.run(config)
        sceneView.delegate = self
        view.addSubview(sceneView)
        
        smileLabel.text = "😐"
        smileLabel.font = UIFont.systemFont(ofSize: 150)
        view.addSubview(smileLabel)
        smileLabel.translatesAutoresizingMaskIntoConstraints = false
        smileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        smileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func handleFacialExpression(leftValue: CGFloat, rightValue: CGFloat) {
        let smileValue = (leftValue + rightValue) / 2.0
        
        switch smileValue {
        case _ where smileValue > 0.5:
            smileLabel.text = "😁"
        case _ where smileValue > 0.2:
            smileLabel.text = "🙂"
        default:
            smileLabel.text = "😐"
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {return}
        let leftSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
        let rightSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
        print(leftSmileValue, rightSmileValue)
        
        DispatchQueue.main.async {
            self.handleFacialExpression(leftValue: leftSmileValue, rightValue: rightSmileValue)
        }
    }
    
}

