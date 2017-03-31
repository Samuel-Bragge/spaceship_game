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
    let hostButton = SKSpriteNode()
    let joinButton = SKSpriteNode()
    
    override func didMove(to view:SKView) {
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
        self.scaleMode = SKSceneScaleMode.aspectFill
        let backgroundImage = SKSpriteNode(texture: SKTextureAtlas(named:"Backgrounds").textureNamed("background"))
        backgroundImage.size = CGSize(width:view.bounds.width, height:view.bounds.height)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        
        // **changed text to look more relaxing for "shootin rocks" lol
        // **adjusted positions of title and buttons to match new menu background
//        let logoText = SKLabelNode(fontNamed: "IowanOldStyle-Bold")
//        logoText.text = "Let's shoot rocks in space "
//        logoText.position = CGPoint(x:0, y:40)
//        logoText.fontSize = 45
//        self.addChild(logoText)
        
        hostButton.texture = textureAtlas.textureNamed("button")
        hostButton.size = CGSize(width:145, height:76)
        hostButton.name = "HostBtn"
        hostButton.position = CGPoint(x:50, y:-100)
        self.addChild(hostButton)
        
        let hostText = SKLabelNode(fontNamed: "IowanOldStyle-Bold")
        hostText.text = "HOST"
        hostText.verticalAlignmentMode = .center
        hostText.position = CGPoint(x:0, y:2)
        hostText.fontSize = 40
        hostText.name = "HostBtn"
        hostText.zPosition = 5
        hostButton.addChild(hostText)
        
        joinButton.texture = textureAtlas.textureNamed("button")
        joinButton.size = CGSize(width:145, height:76)
        joinButton.name = "JoinBtn"
        joinButton.position = CGPoint(x:205, y:-100)
        self.addChild(joinButton)
        
        let joinText = SKLabelNode(fontNamed: "IowanOldStyle-Bold")
        joinText.text = "JOIN"
        joinText.verticalAlignmentMode = .center
        joinText.position = CGPoint(x:0, y:2)
        joinText.fontSize = 40
        joinText.name = "JoinBtn"
        joinText.zPosition = 5
        joinButton.addChild(joinText)
        
        // start button animation
        let pulseAction = SKAction.sequence([SKAction.fadeAlpha(to: 0.5 , duration: 0.9), SKAction.fadeAlpha(to: 1, duration: 0.9)])
        hostText.run(SKAction.repeatForever(pulseAction))
        joinText.run(SKAction.repeatForever(pulseAction))
    }
    
    // press start button transitions to main game scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            print(touch)
            let location = touch.location(in:self)
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "HostBtn" {
                let newScene = GameScene(fileNamed:"GameScene")
                print("Nil? \(newScene)")
                print("Checkpoint 1A")
                newScene?.isHost = true
                let transition = SKTransition.fade(withDuration: 0.8)
                newScene?.scaleMode = SKSceneScaleMode.aspectFill
                self.view?.presentScene(newScene!, transition:transition)
            }
            else if nodeTouched.name == "JoinBtn" {
                let newScene = GameScene(fileNamed:"GameScene")
                print("Nil? \(newScene)")
                print("Checkpoint 1B")
                newScene?.isHost = false
                let transition = SKTransition.fade(withDuration: 0.8)
                newScene?.scaleMode = SKSceneScaleMode.aspectFill
                self.view?.presentScene(newScene!, transition:transition)
            }
        }
    }
}
