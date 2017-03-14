//
//  BossSpawnAnimation.swift
//  spaceships
//
//  Created by Jackie Thind on 3/13/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit
class BossSpawnAnimation: SKSpriteNode {
    
    var initialSize:CGSize = CGSize(width: 200, height: 100)
    
    func onTap() {
    }
    
    init() {
        super.init(texture: SKTexture(imageNamed: "boss-ship"), color: .gray, size: initialSize)
    }
    
    func spawnAnimation() {
        self.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.2, duration: 0.2), SKAction.fadeAlpha(to: 1, duration: 0.2), SKAction.fadeAlpha(to: 0.2, duration: 0.2), SKAction.fadeAlpha(to: 1, duration: 0.2), SKAction.fadeAlpha(to: 0, duration: 0.2)]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
