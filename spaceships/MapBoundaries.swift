//
//  MapBoundaries.swift
//  spaceships
//
//  Created by Jonathan Salin Lee on 3/28/17.
//  Copyright © 2017 Salin Studios. All rights reserved.
//

import Foundation
import SpriteKit

class MapBoundaries: SKSpriteNode {
    var outOfBoundsTimer: Double = 5
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 5000, height: 5000))
        self.position = CGPoint(x: -500, y: -500)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        // test purposes
        self.zPosition = -3
//        self.alpha = 0.2
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.map.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship.rawValue | PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.map.rawValue
    }
    
    func inBounds(player: Player) -> Bool {
        if self.contains(player.position) {
            return true
        } else {
            return false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
