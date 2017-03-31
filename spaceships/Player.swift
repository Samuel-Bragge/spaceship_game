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
    var damage = 0
    var initialSize: CGSize = CGSize(width:50, height:50)
    var initialPos: CGPoint = CGPoint(x: 150, y: 200)
    var textureAtlas = SKTextureAtlas(named: "Spaceship")
    
    init() {
        super.init(texture: SKTexture(imageNamed:"Spaceship"), color: .clear, size: initialSize)
        self.position = initialPos
//        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody = SKPhysicsBody(texture: textureAtlas.textureNamed("Spaceship"), size: textureAtlas.textureNamed("Spaceship").size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.mass = 0.025
        self.physicsBody?.restitution = 0.5
        self.physicsBody?.categoryBitMask = PhysicsCategory.spaceship.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.map.rawValue | PhysicsCategory.enemy.rawValue | PhysicsCategory.enemyLaser.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.enemyLaser.rawValue
        
//        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.powerup.rawValue
//        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy.rawValue | ~PhysicsCategory.debris.rawValue
    }
    
    func shieldsUp() {
        self.shielded = true
        self.texture = textureAtlas.textureNamed("redship")
    }
    
    func shieldsDown() {
        shielded = false
        self.texture = textureAtlas.textureNamed("Spaceship")
    }
    
    func collision(other: SKPhysicsBody) {
        switch other.categoryBitMask {
        case PhysicsCategory.enemy.rawValue:
            print("Player collided with an asteroid")
        case PhysicsCategory.enemyLaser.rawValue:
            print("Player got hit by a laser")
//            let playerVelocity = sqrt(pow(Double((self.physicsBody?.velocity.dx)!), 2) + pow(Double((self.physicsBody?.velocity.dy)!), 2))
//            let rockVelocity = sqrt(pow(Double(other.velocity.dx), 2) + pow(Double(other.velocity.dy), 2))
//            
//            let playerDamageX = pow(Double((self.physicsBody?.velocity.dx)!) - Double(other.velocity.dx), 2)
//            let playerDamageY = pow(Double((self.physicsBody?.velocity.dy)!) - Double(other.velocity.dy), 2)
//            self.damage = Int(sqrt(playerDamageX + playerDamageY) * 0.1)
//            if damage > 5 {
////                self.health -= self.damage
//            }
//            print(damage)
        default:
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
