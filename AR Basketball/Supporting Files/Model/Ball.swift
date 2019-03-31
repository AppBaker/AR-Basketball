//
//  Ball.swift
//  AR Basketball
//
//  Created by Ivan Nikitin on 30/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import ARKit

class  Ball: SCNNode {
    
    var contactDetectionOne = false
    var contactDetectionTwo = false
    var isCounted = false
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
