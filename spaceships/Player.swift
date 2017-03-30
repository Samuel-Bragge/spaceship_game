//
//  Spaceship.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//
import SpriteKit

class Player: SKSpriteNode {
    var health = 100
    var energy = 100
    var shielded = false
    var energyRefreshRate = 0.1
    var energyRegen = 2
    var initialSize: CGSize = CGSize(width:50, height:50)
    var initialPos: CGPoint?
    
    init() {
        super.init(texture: SKTexture(imageNamed:"Spaceship"), color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.spaceship.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.map.rawValue
        self.physicsBody?.collisionBitMask = 0
        
//        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.powerup.rawValue
//        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy.rawValue | ~PhysicsCategory.debris.rawValue
    }
    
    func shieldsUp(manager: PeerServiceManager) {
        self.shielded = true
        self.texture = SKTexture(imageNamed: "redship")
        manager.send(gameState: [0, (self.position.x), (self.position.y), (self.zRotation), (self.physicsBody?.velocity.dx)!, (self.physicsBody?.velocity.dy)!, (1.0)])
    }
    
    func shieldsDown(manager: PeerServiceManager) {
        shielded = false
        self.texture = SKTexture(imageNamed: "Spaceship")
        manager.send(gameState: [0, (self.position.x), (self.position.y), (self.zRotation), (self.physicsBody?.velocity.dx)!, (self.physicsBody?.velocity.dy)!, (0.0)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
