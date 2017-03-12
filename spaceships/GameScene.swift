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
    var playerHealth = 10
    var energy = 100
    var score = 0
    var rocks = 0
    var shielded = false
    var energyTimer = ENERGY_RECHARGE
    var rockTimer = ROCK_SPAWNRATE
    var scoreTimer = SCORE_TICKRATE
    var lastTime:TimeInterval?
    var energyLabel:UILabel?
    var healthLabel:UILabel?
    var scoreLabel:UILabel?
    let initialPlayerPosition = CGPoint(x:150, y:250)
    var playerProgress = CGFloat()
    var backgrounds: [Background] = []
    
    
    override func didMove(to view: SKView) {
        // Game Variables
        playerHealth = 10
        energy = 100
        score = 0
        rocks = 0
        // End Game Variables
        
        self.anchorPoint = .zero
        self.camera = cam
        self.physicsWorld.contactDelegate = self
        
        healthLabel = UILabel(frame: CGRect(x: 150, y: 0, width: 200, height: 21))
        healthLabel?.textAlignment = NSTextAlignment.center
        healthLabel?.text = "Health: \(playerHealth)"
        healthLabel?.textColor = .white
//        self.view!.addSubview(healthLabel!)
        
        energyLabel = UILabel(frame: CGRect(x: 300, y: 0, width: 200, height: 21))
        energyLabel?.textAlignment = NSTextAlignment.center
        energyLabel?.text = "Energy: \(energy)"
        energyLabel?.textColor = .white
//        self.view!.addSubview(energyLabel!)
        
        scoreLabel = UILabel(frame: CGRect(x: 25, y: 0, width: 200, height: 21))
        scoreLabel?.textAlignment = NSTextAlignment.left
        scoreLabel?.text = "Score: \(score)"
        scoreLabel?.textColor = .white
//        self.view!.addSubview(scoreLabel!)
        
        var frame: CGRect = (healthLabel?.frame)!
        let xPosition: CGFloat = view.frame.width - frame.width
        frame.origin = CGPoint(x: ceil(xPosition), y: 0.0)
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        
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
            rock.position = CGPoint(x:Double(arc4random_uniform(500)), y:Double(arc4random_uniform(500)))
        } while(abs(rock.position.x-playerInstance!.position.x) < 100 && abs(rock.position.y-playerInstance!.position.y) < 100)
        self.addChild(rock)
        rocks += 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let firsttouch = touches.first {
//            playerRespondToTouch(firstTouch: firsttouch)
//        }
        for touch in touches {
            if touch.location(in: view).x > view!.frame.width/2 {
                fireLaser()
            }
            else if energy >= 50{
                shielded = true
                playerInstance?.texture = SKTexture(imageNamed: "redship")
            }
        }
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
            energyLabel?.text = "Energy: \(energy)"
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
        if lastTime == nil {
            lastTime = currentTime
        }
        let elapsed = currentTime - lastTime!
        energyTimer -= elapsed
        if energyTimer <= 0 {
            if shielded {
                energy -= 2
                if energy < 50 {
                    print("out of energy!")
                    shielded = false
                    playerInstance?.texture = SKTexture(imageNamed:"Spaceship")
                }
            }
            energy += 1
            if energy > 100 {
                energy = 100
            }
            energyTimer = ENERGY_RECHARGE
        }
        scoreTimer -= elapsed
        if scoreTimer <= 0 {
            score += 3
            scoreTimer = SCORE_TICKRATE
        }
        rockTimer -= elapsed
        if rockTimer <= 0 {
            addRock()
            rockTimer = ROCK_SPAWNRATE
        }
        scoreLabel?.text = "Score: \(score)"
        energyLabel?.text = "Energy: \(energy)"
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
                playerHealth -= 1
                energy -= 50
            }
            healthLabel?.text = "Health: \(playerHealth)"
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
                    break;
                case "corrosive":
                    playerHealth -= 1
                    break;
                case "energy":
                    energy += 50
                    break;
                default:
                    break;
            }
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

enum PhysicsCategory:UInt32 {
    case spaceship = 1
    case damagedSpaceship = 2
    case enemy = 4
    case laser = 8
    case powerup = 16
    case debris = 32
}
