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
    var initialSize: CGSize = CGSize(width:50, height:50)
    var initialPos: CGPoint = CGPoint(x: 150, y: 250)
    
    init() {
        super.init(texture: SKTexture(imageNamed:"Spaceship"), color: .clear, size: initialSize)
        self.position = initialPos
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.spaceship.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.powerup.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy.rawValue | ~PhysicsCategory.debris.rawValue
    }
    
    func shieldsUp() {
        self.shielded = true
        self.texture = SKTexture(imageNamed: "redship")
    }
    
    func shieldsDown() {
        shielded = false
        self.texture = SKTexture(imageNamed: "Spaceship")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}