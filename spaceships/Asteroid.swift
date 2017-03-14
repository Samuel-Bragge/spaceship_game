//
//  Asteroid.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode, GameSprite {
    var initialSize:CGSize = CGSize(width:75, height:60)
    
    func onTap() {
    }
    init() {
        let rand = arc4random_uniform(2)+1
        super.init(texture: SKTexture(imageNamed:"meteorGrey_big\(rand)"), color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.velocity = CGVector(dx:Int(arc4random_uniform(200))-100, dy:Int(arc4random_uniform(200))-100)
        self.physicsBody?.linearDamping = 0
        self.zRotation = CGFloat(drand48()*M_PI*2.0)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask =
            ~PhysicsCategory.damagedSpaceship.rawValue & ~PhysicsCategory.debris.rawValue
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
