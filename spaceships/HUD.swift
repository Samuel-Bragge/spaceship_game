//
//  HUD.swift
//  spaceships
//
//  Created by Jonathan Salin Lee on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    let scoreText = SKLabelNode(text: "00000")
    let energyText = SKLabelNode(text: "")
    let healthText = SKLabelNode(text: "")
    
    func createHudNodes(screenSize:CGSize) {
        let cameraOrigin = CGPoint(
            x: screenSize.width / 2,
            y: screenSize.height / 2)
        print (cameraOrigin)
        let scoreTextPosition = CGPoint (x: -cameraOrigin.x + 40, y: cameraOrigin.y - 500)
        scoreText.position = scoreTextPosition
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(scoreText)
        
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
        
    }
    
    func setScoreDisplay(newScore: Int) {
        let formatter = NumberFormatter()
        let number = NSNumber(value: newScore)
        formatter.minimumIntegerDigits = 6
        if let scoreStr = formatter.string(from: number) {
            scoreText.text = scoreStr
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
