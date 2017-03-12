//
//  Powerup.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class Powerup: SKSpriteNode, GameSprite {
    var power:Int?
    var initialSize:CGSize = CGSize(width:20, height:20)
    
    func onTap() {
    }
    init() {
        super.init(texture: nil, color: .red, size: initialSize)
        power = Int(arc4random_uniform(3))
        switch(power!) {
        case 0:
            self.color = .red; // health
            self.name = "healthpack"
        case 1:
            self.color = .green; // hurt
            self.name = "corrosive"
        case 2:
            self.color = .blue; // energy
            self.name = "energy"
        default:
            self.color = .white; // wtf
            self.name = "error"
        }
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.velocity = CGVector(dx:Int(arc4random_uniform(100))-50, dy:Int(arc4random_uniform(100))-50)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
        self.physicsBody?.collisionBitMask =
            ~PhysicsCategory.damagedSpaceship.rawValue | ~PhysicsCategory.debris.rawValue
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
