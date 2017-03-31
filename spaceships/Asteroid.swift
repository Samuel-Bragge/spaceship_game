//
//  Asteroid.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
//    let randWidth = Double(arc4random_uniform(31) + 90)
//    let randHeight = Double(arc4random_uniform(21) + 80)
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
//        let initialSize = CGSize(width: self.randWidth, height: self.randHeight)
        let rand = arc4random_uniform(4)+1
        let whichRock = SKTexture(imageNamed: "meteorBrown_big\(rand)")
        super.init(texture: whichRock, color: .clear, size: whichRock.size())
//        self.position = CGPoint(x: Double(arc4random_uniform(3878) + 61), y: Double(arc4random_uniform(3878) + 61))
        self.position = CGPoint(x: x, y: y)
        self.zRotation = z
        self.physicsBody = SKPhysicsBody(texture: whichRock, size: whichRock.size())
//        self.physicsBody?.velocity = CGVector(dx:Int(arc4random_uniform(200))-100, dy:Int(arc4random_uniform(200))-100)
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
//        self.zRotation = CGFloat(drand48()*Double.pi*2.0)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0.5
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship.rawValue | PhysicsCategory.laser.rawValue | PhysicsCategory.map.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.spaceship.rawValue | PhysicsCategory.enemy.rawValue
        
//******* Disabled for peer-to-peer demonstration **********
// Re-enable after proper back-end is set up
        self.physicsBody?.isDynamic = false
//**********************************************************
    }
    
    func spawn(player: Player) {
        while (abs(self.position.x - player.position.x) < 100 || abs(self.position.y - player.position.y) < 100){
            self.position = CGPoint(x: Double(arc4random_uniform(3878) + 61), y: Double(arc4random_uniform(3878) + 61))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
