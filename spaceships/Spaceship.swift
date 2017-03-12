//
//  Spaceship.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//
import SpriteKit

class Spaceship: SKSpriteNode, GameSprite {
    var initialSize:CGSize = CGSize(width:50, height:50)
    //    var baseImage:SKSpriteNode = SKSpriteNode(imageNamed:"Spaceship")
    
    func onTap() {
    }
    init() {
        super.init(texture: SKTexture(imageNamed:"Spaceship"), color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.spaceship.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.powerup.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy.rawValue | ~PhysicsCategory.debris.rawValue
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
