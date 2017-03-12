//
//  GameScene.swift
//  Spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Coding Dojo
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    let motionManager = CMMotionManager()
    var playerInstance:SKSpriteNode?
    let playerSpeed:Double = 300
    let cam = SKCameraNode()
    let hud = HUD()
    var playerHealth = MAX_PLAYER_HEALTH
    var energyAnimate = false
    var healthAnimate = false
    var energy = 100
    var score = 0
    var rocks = 0
    var shielded = false
    var energyTimer = ENERGY_RECHARGE
    var rockTimer = ROCK_SPAWNRATE
    var scoreTimer = SCORE_TICKRATE
    var lastTime:TimeInterval?
    let initialPlayerPosition = CGPoint(x:150, y:250)
    var playerProgress = CGFloat()
    var backgrounds: [Background] = []
    var gameOver = false
    
    
    override func didMove(to view: SKView) {
        self.scaleMode = SKSceneScaleMode.aspectFill
        self.motionManager.startAccelerometerUpdates()
        // Game Variables
        playerHealth = MAX_PLAYER_HEALTH
        energy = 100
        score = 0
        rocks = 0
        gameOver = false
        // End Game Variables
        
        self.anchorPoint = .zero
        self.camera = cam
        self.physicsWorld.contactDelegate = self
        // HUD initialization
        self.addChild(self.camera!)
        self.camera!.zPosition = 50
        hud.createHudNodes(screenSize: self.size)
        self.camera!.addChild(hud)
        
        let player = Spaceship()
        playerInstance = player
        player.position = CGPoint(x:150, y:150)
        self.addChild(player)
        
        for _ in 1...15 {
            addRock()
        }
        for _ in 0..<3 {
            backgrounds.append(Background())
        }
        //        backgrounds[0].spawn(parentNode: self, imageName: "background-front", zPosition: -5, movementMultiplier: 0.75)
        //        backgrounds[1].spawn(parentNode: self, imageName: "background-middle", zPosition: -10, movementMultiplier: 0.5)
        backgrounds[2].spawn(parentNode: self, imageName: "background-back", zPosition: -15, movementMultiplier: 0.2)
    }
    func addRock() {
        let rock = Asteroid()
        repeat {
            var x_mult:Double = 1
            var y_mult:Double = 1
            if arc4random_uniform(2) == 0 {
                x_mult = -1
            }
            if arc4random_uniform(2) == 0 {
                y_mult = -1
            }
            let rock_x = Double(playerInstance!.position.x)+x_mult*Double(arc4random_uniform(200)+100)
            let rock_y = Double(playerInstance!.position.y)+y_mult*Double(arc4random_uniform(200)+100)
            
            rock.position = CGPoint(x:rock_x, y:rock_y)
        } while(abs(rock.position.x-playerInstance!.position.x) < 100 && abs(rock.position.y-playerInstance!.position.y) < 100)
        self.addChild(rock)
        rocks += 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !gameOver {
                if touch.location(in: view).x > view!.frame.width/2 {
                    fireLaser()
                }
                else if energy >= 50{
                    shielded = true
                    playerInstance?.texture = SKTexture(imageNamed: "redship")
                }
                else if energy < 50 {
                     hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
                }
            }
            else {
                let location = touch.location(in: self)
                // Locate the node at this location:
                let nodeTouched = atPoint(location)
                // Attempt to downcast the node to the GameSprite protocol
                if let gameSprite = nodeTouched as? GameSprite {
                    // If this node adheres to GameSprite, call onTap:
                    gameSprite.onTap()
                }
                // Check for HUD buttons:
                if nodeTouched.name == "restartGame" {
                    // Transition to a new version of the GameScene
                    // to restart the game:
                    self.view?.presentScene(
                        GameScene(size: self.size),
                        transition: .crossFade(withDuration: 0.6))
                }
                else if nodeTouched.name == "returnToMenu" {
                    // Transition to the main menu scene:'
                    
                    self.view?.presentScene(
                        MenuScene(size: self.size),
                        transition: .crossFade(withDuration: 0.6))
                }
            }

        }
        
        
        // asodf;nasdnf
            }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.location(in: view).x < view!.frame.width/2 {
                shielded = false
                playerInstance?.texture = SKTexture(imageNamed:"Spaceship")
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.previousLocation(in: view).x < view!.frame.width/2 && touch.location(in: view).x > view!.frame.width/2 {
                shielded = false
                playerInstance?.texture = SKTexture(imageNamed:"Spaceship")
            }
        }
    }

    func fireLaser() {
        if energy >= 10 {
            let offset = CGPoint(x:(playerInstance?.position.x)! + cos(((playerInstance?.zRotation)!+CGFloat(M_PI/2)))*(playerInstance?.size.width)!*0.67, y:(playerInstance?.position.y)! + sin(((playerInstance?.zRotation)!+CGFloat(M_PI/2)))*(playerInstance?.size.width)!*0.67)
            let laser = Laser()
            laser.physicsBody?.velocity = CGVector(dx: 300*cos(((playerInstance?.zRotation)!+CGFloat(M_PI/2))), dy: 300*sin(((playerInstance?.zRotation)!+CGFloat(M_PI/2))))
            laser.zRotation = (playerInstance?.zRotation)!
            laser.position = offset
            self.addChild(laser)
            energy -= 10
            hud.setEnergyDisplay(newEnergy: energy)
        }
        else {
            hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
        }
    }
    
    func spawnPowerUp(location:CGPoint) {
        let power = Powerup()
        power.position = location
        self.addChild(power)
    }
    
    override func didSimulatePhysics() {
        self.camera!.position = playerInstance!.position
        
    }
    override func update(_ currentTime: TimeInterval) {
        if playerHealth <= 0 && !gameOver{
            hud.showButtons()
            gameOver = true
        }
        if lastTime == nil {
            lastTime = currentTime
        }
        let elapsed = currentTime - lastTime!
        if !gameOver {
            energyTimer -= elapsed
        }
        if energyTimer <= 0 {
            if shielded {
                energy -= 2
                if energy < 50 {
                    hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
                    shielded = false
                    playerInstance?.texture = SKTexture(imageNamed:"Spaceship")
                }
            }
            energy += 1
            if energy > 100 {
                energy = 100
            }
            hud.setEnergyDisplay(newEnergy: energy)
            energyTimer = ENERGY_RECHARGE
        }
        scoreTimer -= elapsed
        if scoreTimer <= 0 {
            score += 3
            hud.setScoreDisplay(newScore: score)
            scoreTimer = SCORE_TICKRATE
        }
        rockTimer -= elapsed
        if rockTimer <= 0 {
            addRock()
            rockTimer = ROCK_SPAWNRATE-(0.2*(15-Double(rocks)))
        }
        hud.setHealthDisplay(newHealth: playerHealth)
        lastTime = currentTime
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount: CGFloat
            var movement = CGVector()
            playerInstance?.zRotation = CGFloat(atan2(-accelData.acceleration.x,accelData.acceleration.y)-Double(M_PI/2))
            switch
            UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                forceAmount = 35
            case .landscapeRight:
                forceAmount = -35
            default:
                forceAmount = 0
            }
            if accelData.acceleration.y > 0.15 {
                movement.dx = forceAmount
            }
            else if accelData.acceleration.y < -0.15 {
                movement.dx = -forceAmount
            }
            if accelData.acceleration.x > 0.15 {
                movement.dy = -forceAmount
            }
            else if accelData.acceleration.x < -0.15 {
                movement.dy = forceAmount
            }
            playerInstance?.physicsBody?.applyForce(movement)
            // speed cap
            if (playerInstance?.physicsBody?.velocity.dx)! > CGFloat(MAX_PLAYER_SPEED) {
                playerInstance?.physicsBody?.velocity.dx = CGFloat(MAX_PLAYER_SPEED)
            }
            else if (playerInstance?.physicsBody?.velocity.dx)! < CGFloat(-MAX_PLAYER_SPEED) {
                playerInstance?.physicsBody?.velocity.dx = CGFloat(-MAX_PLAYER_SPEED)
            }
            if (playerInstance?.physicsBody?.velocity.dy)! > CGFloat(MAX_PLAYER_SPEED) {
                playerInstance?.physicsBody?.velocity.dy = CGFloat(MAX_PLAYER_SPEED)
            }
            else if (playerInstance?.physicsBody?.velocity.dy)! < CGFloat(-MAX_PLAYER_SPEED) {
                playerInstance?.physicsBody?.velocity.dy = CGFloat(-MAX_PLAYER_SPEED)
            }
        }

    }
    func didBegin(_ contact: SKPhysicsContact){
        let playerMask = PhysicsCategory.spaceship.rawValue | PhysicsCategory.damagedSpaceship.rawValue
        let laserMask = PhysicsCategory.laser.rawValue
        if (contact.bodyA.categoryBitMask & playerMask) > 0 {
            playerCollision(other:contact.bodyB)
        }
        else if (contact.bodyA.categoryBitMask & laserMask) > 0 {
            laserCollision(laser:contact.bodyA, other:contact.bodyB)
        }
        else {
            if (contact.bodyB.categoryBitMask & playerMask) > 0 {
                playerCollision(other:contact.bodyA)
            }
            else if (contact.bodyB.categoryBitMask & laserMask) > 0 {
                laserCollision(laser:contact.bodyB, other: contact.bodyA)
            }
        }
    }
    func playerCollision(other:SKPhysicsBody) {
        switch other.categoryBitMask {
        case PhysicsCategory.enemy.rawValue:

        if shielded {
            energy -= 50
            hud.setEnergyDisplay(newEnergy: energy)
            hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
        }
        else {
            playerHealth -= 1
            hud.setHealthDisplay(newHealth: playerHealth)
            hud.healthText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
        }
        let loc = other.node?.position
        other.node?.run(SKAction.removeFromParent())
        rocks -= 1
        for _ in 1...3 {
            let bits = Debris()
            bits.position = loc!
            self.addChild(bits)
        }
        if(arc4random_uniform(10) == 0) {
            spawnPowerUp(location: loc!)
        }
        case PhysicsCategory.powerup.rawValue:
            if let powertype = other.node?.name {
                switch(powertype) {
                case "healthpack":
                    playerHealth += 1
                    if playerHealth > MAX_PLAYER_HEALTH {
                        playerHealth = MAX_PLAYER_HEALTH
                    }
                    break;
                case "corrosive":
                    playerHealth -= 1
                    hud.setHealthDisplay(newHealth: playerHealth)
                    hud.healthText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
                    break;
                case "energy":
                    energy += 50
                    break;
                default:
                    break;
            }
            other.node?.run(SKAction.removeFromParent())
        }
        default:
            print("Unknown!")
        }
    }
    func laserCollision(laser: SKPhysicsBody, other:SKPhysicsBody) {
        switch other.categoryBitMask {
        case PhysicsCategory.enemy.rawValue:
            score += 10
            laser.node?.run(SKAction.removeFromParent())
            let loc = other.node?.position
            other.node?.run(SKAction.removeFromParent())
            rocks -= 1
            for _ in 1...3 {
                let bits = Debris()
                bits.position = loc!
                self.addChild(bits)
            }
            if(arc4random_uniform(10) == 0) {
                spawnPowerUp(location: loc!)
            }
        default:
            print("Unknown!")
        }
        
    }
}

let ENERGY_RECHARGE = 0.1
let SCORE_TICKRATE = 2.0
let ROCK_SPAWNRATE = 5.0
let MAX_PLAYER_SPEED = 300
let MAX_PLAYER_HEALTH = 3

enum PhysicsCategory:UInt32 {
    case spaceship = 1
    case damagedSpaceship = 2
    case enemy = 4
    case laser = 8
    case powerup = 16
    case debris = 32
}
