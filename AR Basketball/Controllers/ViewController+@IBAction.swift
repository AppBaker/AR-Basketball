//
//  ViewController+@IBAction.swift
//  AR Basketball
//
//  Created by Ivan Nikitin on 27/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import ARKit


extension ViewController {
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        
        if !hoopAdded {
            let location = sender.location(in: sceneView)
            let results = sceneView.hitTest(location, types:  [.existingPlaneUsingExtent])
            guard let result = results.first else { return }
            addHook(result: result)
            
        } else {
            
            addBasketBall()
            
        }
        

    }
}
