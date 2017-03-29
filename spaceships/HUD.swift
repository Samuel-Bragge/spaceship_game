//
//  HUD.swift
//  spaceships
//
//  Created by Jonathan Salin Lee on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit
import UIKit

class HUD: SKNode {
    var score = 0
    let scoreText = SKLabelNode(text: "Score: 000000")
    var scoreTickRate = 2.0
    let hiScoreText = SKLabelNode(text: "High Score: 000000")
    var energyBar: [SKSpriteNode] = []
    var emptyEnergyBar: [SKSpriteNode] = []
    var healthBar: [SKSpriteNode] = []
    var emptyHealthBar: [SKSpriteNode] = []
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    let textureAtlas = SKTextureAtlas(named: "HUD")
    var hiScore:Int?
    var indicator: SKSpriteNode?
    var origin = SKNode()
    
    // initialize HUD - score, highscore, health bars, energy bar, game over screen
    func createHudNodes(screenSize:CGSize) {
        if UserDefaults.standard.object(forKey: "hiscore") == nil {
            UserDefaults.standard.set(0, forKey: "hiscore")
            UserDefaults.standard.synchronize()
            hiScore = 0
        }
        else {
            hiScore = UserDefaults.standard.object(forKey:"hiscore") as? Int
        }
        let cameraOrigin = CGPoint(
            x: screenSize.width / 2,
            y: screenSize.height / 2)
        print (cameraOrigin)
        
        indicator = SKSpriteNode(texture: textureAtlas.textureNamed("indicatorArrow"))
//        let indicatorPosition = CGPoint(x: frame.width / 2, y: frame.height / 2)
//        indicator?.position = indicatorPosition
        indicator?.alpha = 0
        indicator?.size = CGSize(width: 9, height: 12)
        
        // score area
        let scoreTextPosition = CGPoint (x: -cameraOrigin.x + 40, y: cameraOrigin.y - 500)
        scoreText.position = scoreTextPosition
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(scoreText)
        
        // high score area
        let hiScoreTextPosition = CGPoint (x: -cameraOrigin.x + 450, y: cameraOrigin.y - 500)
        hiScoreText.position = hiScoreTextPosition
        hiScoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        hiScoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(hiScoreText)
        setHiScoreDisplay(newHiScore:hiScore!)
        
        
        // new health bars
//        for index in 0..<5 {
//            let newHealthNode = SKSpriteNode(texture: textureAtlas.textureNamed("healthBar"))
//            newHealthNode.size = CGSize(width: 30, height: 20)
//            let xPos = -cameraOrigin.x + CGFloat(index * 35) + 55
//            let yPos = cameraOrigin.y - 530
//            newHealthNode.position = CGPoint(x: xPos, y: yPos)
//            healthNodes.append(newHealthNode)
//            self.addChild(newHealthNode)
//            
//            // Bar background
//            let emptyHealthNode = SKSpriteNode(texture: textureAtlas.textureNamed("emptyHealthBar"))
//            emptyHealthNode.size = CGSize(width: 30, height: 20)
//            emptyHealthNode.position = CGPoint(x: xPos, y: yPos)
//            emptyHealthNodes.append(emptyHealthNode)
//            self.addChild(emptyHealthNode)
//        }
        for index in 0..<100 {
            var healthBarNode = SKSpriteNode()
            if index == 0 {
                healthBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("healthBarLeft"))
            } else if index == 99 {
                healthBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("healthBarRight"))
            } else {
                healthBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("healthBarMid"))
            }
            healthBarNode.size = CGSize(width: 2, height: 10)
            let xPos = -cameraOrigin.x + CGFloat(index * 2) + 42
            let yPos = cameraOrigin.y - 530
            healthBarNode.position = CGPoint(x: xPos, y: yPos)
            healthBar.append(healthBarNode)
            self.addChild(healthBarNode)
            
            var emptyHealthBarNode = SKSpriteNode()
            if index == 0 {
                emptyHealthBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("emptyBarLeft"))
            } else if index == 99 {
                emptyHealthBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("emptyBarRight"))
            } else {
                emptyHealthBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("emptyBarMid"))
            }
            emptyHealthBarNode.size = CGSize(width: 2, height: 10)
            emptyHealthBarNode.position = CGPoint(x: xPos, y: yPos)
            emptyHealthBar.append(emptyHealthBarNode)
            self.addChild(emptyHealthBarNode)
        }

        
        // new energy bar
        for index in 0..<100 {
            var energyBarNode = SKSpriteNode()
            if index == 0 {
                energyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("energyBarLeft"))
            } else if index == 99 {
                energyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("energyBarRight"))
            } else {
                energyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("energyBarMiddle"))
            }
            energyBarNode.size = CGSize(width: 2, height: 10)
            let xPos = -cameraOrigin.x + CGFloat(index * 2) + 42
            let yPos = cameraOrigin.y - 555
            energyBarNode.position = CGPoint(x: xPos, y: yPos)
            energyBar.append(energyBarNode)
            self.addChild(energyBarNode)
            
            var emptyEnergyBarNode = SKSpriteNode()
            if index == 0 {
                emptyEnergyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("emptyBarLeft"))
            } else if index == 99 {
                emptyEnergyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("emptyBarRight"))
            } else {
                emptyEnergyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("emptyBarMid"))
            }
            emptyEnergyBarNode.size = CGSize(width: 2, height: 10)
            emptyEnergyBarNode.position = CGPoint(x: xPos, y: yPos)
            emptyEnergyBar.append(emptyEnergyBarNode)
            self.addChild(emptyEnergyBarNode)
        }
        
        // Add the restart and menu button textures to the nodes:
        restartButton.texture =
            textureAtlas.textureNamed("button-restart")
        menuButton.texture =
            textureAtlas.textureNamed("button-menu")
        // Assign node names to the buttons:
        restartButton.name = "restartGame"
        menuButton.name = "returnToMenu"
        menuButton.position = CGPoint(x: -140, y: 0)
        // Size the button nodes:
        restartButton.size = CGSize(width: 140, height: 140)
        menuButton.size = CGSize(width: 70, height: 70)
        
        
    }
    
    func showButtons() {
        // Set the button alpha to 0:
        restartButton.alpha = 0
        menuButton.alpha = 0
        // Add the button nodes to the HUD:
        self.addChild(restartButton)
        self.addChild(menuButton)
        // Fade in the buttons:
        let fadeAnimation =
            SKAction.fadeAlpha(to: 1, duration: 0.4)
        restartButton.run(fadeAnimation)
        menuButton.run(fadeAnimation)
    }
    
    // score update function
    func setScoreDisplay(newScore: Int) {
        let formatter = NumberFormatter()
        let number = NSNumber(value: newScore)
        formatter.minimumIntegerDigits = 6
        if let scoreStr = formatter.string(from: number) {
            scoreText.text = "Score: " + scoreStr
        }
        if newScore > hiScore! {
            hiScore = newScore
            setHiScoreDisplay(newHiScore: hiScore!)
            UserDefaults.standard.set(hiScore, forKey: "hiscore")
            UserDefaults.standard.synchronize()
        }
    }
    
    // high score update
    func setHiScoreDisplay(newHiScore: Int) {
        let formatter = NumberFormatter()
        let number = NSNumber(value: newHiScore)
        formatter.minimumIntegerDigits = 6
        if let hiScoreStr = formatter.string(from: number) {
            hiScoreText.text = "High Score: " + hiScoreStr
        }
    }
    
    // energy bar updater
    func setEnergyDisplay(newEnergy: Int) {
        let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0)
        for index in 0 ..< energyBar.count {
            if index < newEnergy {
                energyBar[index].alpha = 1
            } else {
                energyBar[index].run(fadeAction)
            }
            
            if index == 0 {
                if energyBar[index].texture == textureAtlas.textureNamed("insuffEnergyLeft") {
                    energyBar[index] = SKSpriteNode(texture: textureAtlas.textureNamed("energyBarLeft"))
                }
            } else if index == 99 {
                if energyBar[index].texture == textureAtlas.textureNamed("insuffEnergyMiddle") {
                    energyBar[index] = SKSpriteNode(texture: textureAtlas.textureNamed("energyBarRight"))
                }
            } else {
                if energyBar[index].texture == textureAtlas.textureNamed("insuffEnergyRight") {
                    energyBar[index] = SKSpriteNode(texture: textureAtlas.textureNamed("energyBarMiddle"))
                }
            }
        }
        
    }
    
    // health bar updater
    func setHealthDisplay(newHealth: Int) {
        let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.3)
        for index in 0 ..< healthBar.count {
            if index < newHealth {
                healthBar[index].alpha = 1
            } else {
                healthBar[index].run(fadeAction)
            }
        }
    }
    
    // function to flash energy bar when the player has insufficient energy
    func insuffEnergyDisplay(newEnergy: Int) {
        let insuffEnergyLeft: [SKTexture] = [textureAtlas.textureNamed("insuffEnergyLeft"), textureAtlas.textureNamed("energyBarLeft")]
        let flashLeft = SKAction.animate(with: insuffEnergyLeft, timePerFrame: 0.1)
        
        let insuffEnergyMid: [SKTexture] = [textureAtlas.textureNamed("insuffEnergyMiddle"), textureAtlas.textureNamed("energyBarMiddle")]
        let flashMiddle = SKAction.animate(with: insuffEnergyMid, timePerFrame: 0.1)
        
        let insuffEnergyRight: [SKTexture] = [textureAtlas.textureNamed("insuffEnergyMiddle"), textureAtlas.textureNamed("energyBarRight")]
        let flashRight = SKAction.animate(with: insuffEnergyRight, timePerFrame: 0.1)
        
        for index in 0 ..< energyBar.count {
            if index == 0 {
                energyBar[index].run(flashLeft)
            } else if index == energyBar.count - 1 {
                energyBar[index].run(flashRight)
            } else {
                energyBar[index].run(flashMiddle)
            }
        }
    }
    
    func addIndicator() {
        indicator = SKSpriteNode(texture: textureAtlas.textureNamed("indicatorArrow"))
        indicator?.alpha = 0
        indicator?.size = CGSize(width: 9, height: 12)
    }
    
    func updateIndicator(target: SKSpriteNode, player: Player) {
        let deltaX = target.position.x - player.position.x
        let deltaY = target.position.y - player.position.y
        let angle = atan2(deltaY, deltaX)
        indicator?.zRotation = angle - CGFloat(Double.pi / 2)
        indicator?.position = CGPoint(x: (frame.width / 2) + cos(angle) * 50, y: (frame.height) + sin(angle) * 50)
    }
    
    func removeIndicator() {
        if let currentIndicator = self.indicator {
            currentIndicator.removeFromParent()
            self.indicator = nil
        }
    }
    // keep energyText and healthText labels for testing purposes, but no longer needed since HUD updates
//    let energyText = SKLabelNode(text: "")
//    let healthText = SKLabelNode(text: "")
        
    // **no longer needed since HUD updates...keep for testing****************
//        let energyTextPosition = CGPoint (x: -cameraOrigin.x + 40, y: cameraOrigin.y - 540)
//        energyText.position = energyTextPosition
//        energyText.fontSize = 16
//        energyText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
//        energyText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
//        self.addChild(energyText)
//        let healthTextPosition = CGPoint (x: -cameraOrigin.x + 40, y: cameraOrigin.y - 522)
//        healthText.position = healthTextPosition
//        healthText.fontSize = 16
//        healthText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
//        healthText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
//        self.addChild(healthText)
// ***********************************************************************
        
        // **no longer needed, keep for testing
//        let formatter = NumberFormatter()
//        let number = NSNumber(value: newEnergy)
//        if let energyStr = formatter.string(from: number) {
////            energyText.text = energyStr + "/100 energy"
//        }
        
        // **no longer needed, keep for testing
//        let formatter = NumberFormatter()
//        let number = NSNumber(value: newHealth)
//        if let healthStr = formatter.string(from: number) {
////            healthText.text = "Health: " + healthStr
//        }

}
