//
//  GameSprite.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

protocol GameSprite {
    //    var baseImage:SKSpriteNode {get set}
    var initialSize: CGSize { get set }
    func onTap()
}
