//
//  Laser.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class Laser: SKSpriteNode {
    var initialSize:CGSize = CGSize(width:3, height:15)

    init() {
        super.init(texture: nil, color: .cyan, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.laser.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.removeFromParent()]))
    }
    
    func fire(player: Player, peerManager: PeerServiceManager) {
        let laserSound = SKAction.playSoundFileNamed("Sound/laser.wav", waitForCompletion: false)
        self.run(laserSound)
        let offset = CGPoint(x:(player.position.x) + cos(((player.zRotation) + CGFloat(Double.pi/2)))*(player.size.width)*0.34, y:(player.position.y) + sin(((player.zRotation) + CGFloat(Double.pi/2)))*(player.size.width)*0.34)
        self.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)! + 300*cos(((player.zRotation) + CGFloat(Double.pi/2))), dy: (player.physicsBody?.velocity.dy)! + 300*sin(((player.zRotation) + CGFloat(Double.pi/2))))
        self.zRotation = (player.zRotation)
        self.position = offset
        peerManager.send(posInfo: [1, self.position.x, self.position.y, self.zRotation, (self.physicsBody?.velocity.dx)!, (self.physicsBody?.velocity.dy)!])
        player.energy -= 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
