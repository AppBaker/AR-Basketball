//
//  ViewController+SCNPhysicsContactDelegate.swift
//  AR Basketball
//
//  Created by Ivan Nikitin on 30/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import ARKit


extension ViewController: SCNPhysicsContactDelegate, SCNSceneRendererDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if contact.nodeB.name == "Ball" && contact.nodeA.name == "DetectPlaneOne" || contact.nodeB.name == "Ball" && contact.nodeA.name == "DetectPlaneTwo" {
            guard let ball = contact.nodeB as? Ball else { return }
            
            if contact.nodeB.name == "Ball" && contact.nodeA.name == "DetectPlaneTwo" {
                ball.contactDetectionTwo = true
            }

            if !ball.contactDetectionOne && contact.nodeA.name == "DetectPlaneOne" && !ball.contactDetectionOne {
                ball.contactDetectionOne = true
                if ball.contactDetectionTwo {
                    ball.isCounted = true
                }
            }

            else if ball.contactDetectionOne && contact.nodeA.name == "DetectPlaneTwo" {
                //Cout score
                if !ball.isCounted {
                    ballInTheBasket()
                    ball.isCounted = true
                }
            }
        }
    }
}
