//
//  Laser.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class Laser:SKSpriteNode {
    var initialSize:CGSize = CGSize(width:3, height:15)
    
    func onTap() {
    }
    init() {
        super.init(texture: nil, color: .cyan, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.laser.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.removeFromParent()]))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
