//
//  Laser.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class EnemyLaser:SKSpriteNode {
    var initialSize:CGSize = CGSize(width:3, height:15)
    
    func onTap() {
    }
    init() {
        super.init(texture: nil, color: .red, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask =
            ~PhysicsCategory.damagedSpaceship.rawValue & ~PhysicsCategory.debris.rawValue & ~PhysicsCategory.enemy.rawValue
        self.run(SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.removeFromParent()]))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
