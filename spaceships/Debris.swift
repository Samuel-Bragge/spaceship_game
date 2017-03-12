//
//  Debris.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class Debris: SKSpriteNode, GameSprite {
    var initialSize:CGSize = CGSize(width:20, height:20)
    
    func onTap() {
    }
    init() {
        let rand = arc4random_uniform(2)+1
        super.init(texture: SKTexture(imageNamed:"meteorGrey_tiny\(rand)"), color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.velocity = CGVector(dx:Int(arc4random_uniform(400))-200, dy:Int(arc4random_uniform(400))-200)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.debris.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.run(SKAction.sequence([SKAction.group([SKAction.wait(forDuration: 0.5),SKAction.fadeAlpha(to: 0 , duration: 0.7)]), SKAction.removeFromParent()]))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
