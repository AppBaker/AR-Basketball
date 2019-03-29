//
//  ViewController+Methods.swift
//  AR Basketball
//
//  Created by Ivan Nikitin on 27/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import ARKit

extension  ViewController {
    
    //MARK: - Adding objects
    func addBasketBall() {
        
        guard let frame = sceneView.session.currentFrame else { return }
        
        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
        ball.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/spalding.png")
        
        let transform = frame.camera.transform
        ball.simdTransform = transform
        
        let shape = SCNPhysicsShape(node: ball, options: [SCNPhysicsShape.Option.collisionMargin : 0.01])
        let body = SCNPhysicsBody(type: .dynamic, shape: shape)
        ball.physicsBody = body
        
        let power = Float(10)
        let cameraTransform = SCNMatrix4(transform)
        var force = SCNVector3(0, 0, -power)
        force.x = -cameraTransform.m31 * 10
        force.y = -cameraTransform.m32 * 10
        force.z = -cameraTransform.m33 * 10
        
        ball.physicsBody?.applyForce(force, asImpulse: true)
        
        
        ball.addChildNode(text)
        sceneView.scene.rootNode.addChildNode(ball)
        
    }
    
    func addHook(result: ARHitTestResult) {
        let scene = SCNScene(named: "art.scnassets/Hoop.scn")
        guard let node = scene?.rootNode.childNode(withName: "hoop", recursively: false) else { return }
         
        node.simdTransform = result.worldTransform
        node.eulerAngles.x -= .pi/2
        node.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: node, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron
            ]))
        
        sceneView.scene.rootNode.enumerateChildNodes{ node , _ in
            if node.name == "Wall" {
                node.removeFromParentNode()
            }
            
        } 
        hoopAdded = true
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    
    func createWall(anchor: ARPlaneAnchor) -> SCNNode {
        let extent = anchor.extent
        let width = CGFloat(extent.x)
        let height = CGFloat(extent.z)
        
        
        let node = SCNNode(geometry: SCNPlane(width: width, height: height))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.eulerAngles.x = -.pi / 2
        node.name = "Wall"
        
        node.opacity = 0.25

        
        return node
    }
}
