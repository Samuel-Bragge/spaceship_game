//
//  Boss.swift
//  spaceships
//
//  Created by Justin Chang on 3/12/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class Boss: SKSpriteNode, GameSprite {
    var initialSize:CGSize = CGSize(width:200, height:100)
    var health = 15
    
    func onTap() {
    }
    init() {
        super.init(texture: SKTexture(imageNamed: "boss-ship"), color: .gray, size: initialSize)
        self.name = "Boss"
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask =
            ~PhysicsCategory.damagedSpaceship.rawValue & ~PhysicsCategory.debris.rawValue
    }
    
    // radial beam pulse
    func beamSpam(scene:SKScene) {
        if health > 0 {
            let laserBass = SKAction.playSoundFileNamed("Sound/boss_bass2.mp3", waitForCompletion: false)
            self.run(laserBass)
            let laserSound = SKAction.playSoundFileNamed("Sound/boss_laser.mp3", waitForCompletion: false)
            self.run(laserSound)
            for i in 0...16 {
                let enemyLaser = EnemyLaser()
                enemyLaser.position = self.position
                enemyLaser.zRotation = CGFloat(Double(i)/8.0*M_PI)+CGFloat(2.0*M_PI)
                enemyLaser.physicsBody?.velocity = CGVector(dx: 300*cos(enemyLaser.zRotation)+CGFloat(M_PI/2), dy: 300*sin(enemyLaser.zRotation)+CGFloat(M_PI/2))
                enemyLaser.name = "bosslaser"
                scene.addChild(enemyLaser)
            }
        }
    }
    
    // **added bool death condition to know when to give player points
    func loseHealth(scene:SKScene) -> Bool{
        var dead = false
        health -= 1
        self.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.2 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0.2 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1)]))
        if health <= 0 {
            dead = true
            die(scene: scene)
            return dead
        }
        return dead
    }
    
    // boss explodes into debris
    func die(scene:SKScene) {
        let asteroidSound = SKAction.playSoundFileNamed("Sound/asteroid.mp3", waitForCompletion: false)
        self.run(asteroidSound)
        self.run(SKAction.removeFromParent())
//        scene.removeAction(forKey: "bossbgm")
        for i in 0...16 {
            let bits = Debris()
            bits.position = self.position
            bits.zRotation = CGFloat(Double(i)/8.0*M_PI)+CGFloat(2.0*M_PI)
            bits.physicsBody?.velocity = CGVector(dx: 300*cos(bits.zRotation)+CGFloat(M_PI/2), dy: 300*sin(bits.zRotation)+CGFloat(M_PI/2))
            scene.addChild(bits)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
