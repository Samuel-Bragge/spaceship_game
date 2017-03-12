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
    let scoreText = SKLabelNode(text: "000000")
    let hiScoreText = SKLabelNode(text: "Hi: 000000")
    let energyText = SKLabelNode(text: "")
    let healthText = SKLabelNode(text: "")
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    let textureAtlas = SKTextureAtlas(named: "HUD")
    var hiScore:Int?
    
    func createHudNodes(screenSize:CGSize) {
        if UserDefaults.standard.object(forKey: "hiscore") == nil {
            UserDefaults.standard.set(0, forKey: "hiscore")
            UserDefaults.standard.synchronize()
            hiScore = 0
        }
        else {
            hiScore = UserDefaults.standard.object(forKey:"hiscore") as! Int
        }
        let cameraOrigin = CGPoint(
            x: screenSize.width / 2,
            y: screenSize.height / 2)
        print (cameraOrigin)
        let scoreTextPosition = CGPoint (x: -cameraOrigin.x + 40, y: cameraOrigin.y - 500)
        scoreText.position = scoreTextPosition
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(scoreText)
        
        let hiScoreTextPosition = CGPoint (x: -cameraOrigin.x + 450, y: cameraOrigin.y - 500)
        hiScoreText.position = hiScoreTextPosition
        hiScoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        hiScoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(hiScoreText)
        setHiScoreDisplay(newHiScore:hiScore!)
        
        let energyTextPosition = CGPoint (x: -cameraOrigin.x + 40, y: cameraOrigin.y - 540)
        energyText.position = energyTextPosition
        energyText.fontSize = 16
        energyText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        energyText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(energyText)
        
        let healthTextPosition = CGPoint (x: -cameraOrigin.x + 40, y: cameraOrigin.y - 522)
        healthText.position = healthTextPosition
        healthText.fontSize = 16
        healthText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        healthText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(healthText)
        
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
    
    func setScoreDisplay(newScore: Int) {
        let formatter = NumberFormatter()
        let number = NSNumber(value: newScore)
        formatter.minimumIntegerDigits = 6
        if let scoreStr = formatter.string(from: number) {
            scoreText.text = scoreStr
        }
        if newScore > hiScore! {
            hiScore = newScore
            setHiScoreDisplay(newHiScore: hiScore!)
            UserDefaults.standard.set(hiScore, forKey: "hiscore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func setHiScoreDisplay(newHiScore: Int) {
        let formatter = NumberFormatter()
        let number = NSNumber(value: newHiScore)
        formatter.minimumIntegerDigits = 6
        if let hiScoreStr = formatter.string(from: number) {
            hiScoreText.text = "Hi: "+hiScoreStr
        }
    }
    
    func setEnergyDisplay(newEnergy: Int) {
        let formatter = NumberFormatter()
        let number = NSNumber(value: newEnergy)
        if let energyStr = formatter.string(from: number) {
            energyText.text = energyStr + "/100 energy"
        }
    }
    
    func setHealthDisplay(newHealth: Int) {
        let formatter = NumberFormatter()
        let number = NSNumber(value: newHealth)
        if let healthStr = formatter.string(from: number) {
            healthText.text = "Health: " + healthStr
        }
    }
}
