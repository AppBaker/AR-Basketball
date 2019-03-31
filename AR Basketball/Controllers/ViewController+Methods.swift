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
        
        let ball = Ball()
        let geometry = SCNSphere(radius: 0.25)
        ball.geometry = geometry
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
        
        // Add torque
        
        ball.physicsBody?.applyTorque(SCNVector4(transform.columns.1.x, transform.columns.1.y, transform.columns.1.z, 0.7), asImpulse: true)
        
        
        ball.physicsBody?.collisionBitMask = 2
        ball.physicsBody?.contactTestBitMask = 1
        ball.physicsBody?.categoryBitMask = 1
        ball.name = "Ball"
        
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
        
        node.addChildNode(createResultScore())
        node.addChildNode(createPlaneDetection().0)
        node.addChildNode(createPlaneDetection().1)
        
        
        sceneView.scene.rootNode.enumerateChildNodes{ node , _ in
            if node.name == "Wall" {
                node.removeFromParentNode()
            }
            
        }

        hoopAdded = true
        
        sceneView.scene.rootNode.addChildNode(node)
        //Remove debugOptions and planeDetection
        sceneView.session.run(ARWorldTrackingConfiguration())
        sceneView.debugOptions.remove(.showFeaturePoints)
    }
    
    
    
    func createWall(anchor: ARPlaneAnchor) -> SCNNode {
        let extent = anchor.extent
        let width = CGFloat(extent.x)
        let height = CGFloat(extent.z)
        
        
        let node = SCNNode(geometry: SCNPlane(width: width, height: height))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.25)
        node.eulerAngles.x = -.pi / 2
        node.name = "Wall"
        
        return node
    }
    
    func createPlaneDetection() -> (SCNNode, SCNNode) {
        
        //Detection plane one
        let detectionNodeOne = SCNNode(geometry: SCNPlane(width: 0.4, height: 0.4))
        detectionNodeOne.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        detectionNodeOne.position = SCNVector3(0, -0.3, 0.595)
        detectionNodeOne.eulerAngles.x = -.pi/2
        detectionNodeOne.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: detectionNodeOne))
        
        detectionNodeOne.physicsBody?.collisionBitMask = 2
        detectionNodeOne.physicsBody?.contactTestBitMask = 1
        detectionNodeOne.physicsBody?.categoryBitMask = 1
        detectionNodeOne.name = "DetectPlaneOne"
        detectionNodeOne.opacity = 0
        
        //Detection plane two
        
        let detectionNodeTwo = SCNNode(geometry: SCNPlane(width: 0.4, height: 0.4))
        detectionNodeTwo.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        detectionNodeTwo.position = SCNVector3(0, -0.65, 0.595)
        detectionNodeTwo.eulerAngles.x = -.pi/2
        detectionNodeTwo.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: detectionNodeTwo))
        
        detectionNodeTwo.physicsBody?.collisionBitMask = 2
        detectionNodeTwo.physicsBody?.contactTestBitMask = 1
        detectionNodeTwo.physicsBody?.categoryBitMask = 1
        detectionNodeTwo.name = "DetectPlaneTwo"
        detectionNodeTwo.opacity = 0
        
        return (detectionNodeOne, detectionNodeTwo)
        
    }
        //Set score on to scoreboard
    func createResultScore() -> SCNNode {
        
        let scoreGeometry = SCNText(string: String(score), extrusionDepth: 0.1)
        scoreGeometry.font = UIFont(name: "Helvetica", size: 12)
        scoreGeometry.flatness = 0
        let resultScoreNode = SCNNode(geometry: scoreGeometry)
        resultScoreNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        resultScoreNode.scale = SCNVector3(0.03, 0.03, 0.03)
        resultScoreNode.position = SCNVector3( 0, 0.73, 0.065)
        scoreNode = resultScoreNode
        return resultScoreNode
    }
    // Count score
    func ballInTheBasket() {
        score += 2
        if score < 10 {
            scoreNode.position.x = 0
        } else if score < 100 {
            scoreNode.position.x = -0.15
        } else {
            scoreNode.position.x = -0.3
        }
        (scoreNode.geometry as! SCNText).string = String(score)
    }

}
