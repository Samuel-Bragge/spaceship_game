//
//  MenuScene.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

//
//  MenuScene.swift
//  spaceship
//
//  Created by Jackie Thind on 3/10/17.
//  Copyright © 2017 JoyfulGames.io. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"HUD")
    let startButton = SKSpriteNode()
    override func didMove(to view:SKView) {
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
        self.scaleMode = SKSceneScaleMode.aspectFill
        let backgroundImage = SKSpriteNode(imageNamed:"background-menu")
        backgroundImage.size = CGSize(width:1024, height:768)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        
        // **changed text to look more relaxing for "shootin rocks" lol
        // **adjusted positions of title and buttons to match new menu background
        let logoText = SKLabelNode(fontNamed: "IowanOldStyle-Bold")
        logoText.text = "Let's shoot rocks in space "
        logoText.position = CGPoint(x:0, y:40)
        logoText.fontSize = 45
        self.addChild(logoText)
        
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width:295, height:76)
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x:100, y:-100)
        self.addChild(startButton)
        
        let startText = SKLabelNode(fontNamed: "IowanOldStyle-Bold")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x:0, y:2)
        startText.fontSize = 40
        startText.name = "StartBtn"
        startText.zPosition = 5
        startButton.addChild(startText)
        
        // start button animation
        let pulseAction = SKAction.sequence([SKAction.fadeAlpha(to: 0.5 , duration: 0.9), SKAction.fadeAlpha(to: 1, duration: 0.9)])
        startText.run(SKAction.repeatForever(pulseAction))
    }
    
    // press start button transitions to main game scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in:self)
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "StartBtn" {
                let newScene = GameScene(fileNamed:"GameScene")
                let transition = SKTransition.fade(withDuration: 0.8)
                newScene?.scaleMode = SKSceneScaleMode.aspectFill
                self.view?.presentScene(newScene!, transition:transition)
            }
        }
    }
}
