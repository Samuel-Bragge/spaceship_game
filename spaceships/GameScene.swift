//
//  GameScene.swift
//  Spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Coding Dojo
//

import SpriteKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    let motionManager = CMMotionManager()
    let cam = SKCameraNode()
    let map = MapBoundaries()
    let hud = HUD()
    var lastTime: TimeInterval?
    let enemyNoShield = SKTexture(imageNamed: "enemyPlayer")
    let enemyShielded = SKTexture(imageNamed: "enemyShield")
    
    let player = Player()
    var opponent:SKSpriteNode?
    var backgrounds: [Background] = []
    var laserArray: [Laser] = []
    var laserId: Int? = 0
    var targetLaserId: Int? = 0
    var rocksArray: [Asteroid] = []
    var malfunctionTimer = 0.0
    var playerProgress = CGFloat()
    var gameOver = false
    
    override func didMove(to view: SKView) {
        print("Checkpoint 2")
        self.scaleMode = SKSceneScaleMode.aspectFill
        
        // Start Core Motion
        self.motionManager.startAccelerometerUpdates()
        
        // Initialize camera
        self.anchorPoint = .zero
        self.camera = cam
//        print(cam.position)
        self.physicsWorld.contactDelegate = self
        
        // Initialize HUD
        self.addChild(self.camera!)
        self.camera!.zPosition = 50
        hud.createHudNodes(screenSize: self.size)
        self.camera!.addChild(hud)
        
        // Set map boundaries
        self.addChild(map)
        // Game Variables

        hud.score = 0
        gameOver = false
        self.addChild(player)
        
        // Add targeting indicator
        hud.addIndicator()
        hud.addChild((hud.indicator!))
        
        // initialize background
//        for _ in 0..<3 {
            backgrounds.append(Background())
        //        }
        backgrounds[0].spawn(parentNode: self, imageName: "spaaace", zPosition: -5, movementMultiplier: 1)
        //backgrounds[1].spawn(parentNode: self, imageName: "background-back", zPosition: -10, movementMultiplier: 0.5)
        //backgrounds[2].spawn(parentNode: self, imageName: "background-back", zPosition: -15, movementMultiplier: 1)
//        for _ in 0..<50 {
//            let asteroid = Asteroid()
//            asteroid.position.x = 
//        }
        
        
        for _ in 1...100 {
            let asteroid = Asteroid()
            asteroid.spawn(player: player)
            rocksArray.append(asteroid)
        }
        
        for i in 0..<100 {
            self.addChild(rocksArray[i])
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Player collisions
        if (contact.bodyA.categoryBitMask & PhysicsCategory.spaceship.rawValue) > 0 {
            player.collision(other: contact.bodyB)
        } else if (contact.bodyB.categoryBitMask & PhysicsCategory.spaceship.rawValue) > 0 {
                player.collision(other: contact.bodyA)
        }
        
        // Laser collisions
        if (contact.bodyA.categoryBitMask & PhysicsCategory.laser.rawValue) > 0 {
            for i in 0...laserArray.count {
                if laserArray[i].physicsBody == contact.bodyA {
                    if (contact.bodyB.categoryBitMask & PhysicsCategory.spaceship.rawValue) < 1 {
                        targetLaserId = laserArray[i].primaryKey
                        laserArray[i].removeFromParent()
                        laserArray.remove(at: i)
                        print("ID of hit laser: \(targetLaserId)")
                        print("Laser destroyed on collision with asteroid - Case: A")
                        break
                    }
                }
            }
        } else if (contact.bodyB.categoryBitMask & PhysicsCategory.laser.rawValue) > 0 {
            for i in 0..<laserArray.count {
                if laserArray[i].physicsBody == contact.bodyB {
                    if (contact.bodyA.categoryBitMask & PhysicsCategory.spaceship.rawValue) < 1 {
                        targetLaserId = laserArray[i].primaryKey
                        laserArray[i].removeFromParent()
                        laserArray.remove(at: i)
                        print("ID of hit laser: \(targetLaserId)")
                        print("Laser destroyed on collision with asteroid - Case: B")
                        break
                    }
                }
            }
        }
        
        // Asteroid collisions
        if (contact.bodyA.categoryBitMask & PhysicsCategory.enemy.rawValue) > 0 {
            
        } else if (contact.bodyB.categoryBitMask & PhysicsCategory.enemy.rawValue) > 0 {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !gameOver {
                
                // tap right side to fire
                if touch.location(in: view).x > view!.frame.width/2 {
                    fireLaser()
                }
                    
                // tap/hold left side to shield
                else if player.energy >= 50{
                    player.shieldsUp()
                }
                else if player.energy < 50 {
                    // Flash energy bar
                    hud.insuffEnergyDisplay(newEnergy: player.energy)
                }
            }
            // gameOver = true
            else {
                let location = touch.location(in: self)
                
                // Locate the node at this location:
                let nodeTouched = atPoint(location)
                
                // Check for HUD buttons:
                // Transition to a new version of the GameScene to restart the game
                if nodeTouched.name == "restartGame" {
                    self.view?.presentScene(
                        GameScene(size: self.size),
                        transition: .crossFade(withDuration: 0.6))
                }
                // Transition to the main menu scene
                else if nodeTouched.name == "returnToMenu" {
                    self.view?.presentScene(
                        MenuScene(size: self.size),
                        transition: .crossFade(withDuration: 0.6))
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // Turn off shield
            if touch.location(in: view).x < view!.frame.width/2 {
                player.shieldsDown()
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Turn off shield
        for touch in touches {
            if touch.previousLocation(in: view).x < view!.frame.width/2 && touch.location(in: view).x > view!.frame.width/2 {
                player.shieldsDown()
            }
        }
    }

    func fireLaser() {
        if player.energy >= 10 {
            laserId? += 1
            let laser = Laser()
            laser.fire(player: player)
            laser.primaryKey = laserId
            self.addChild(laser)
            
            laserArray.append(laser)
            print("# of lasers: \(laserArray.count)")
            if laserArray.count > 12 {
                laserArray.remove(at: 0)
            }
            
//            for i in 0..<laserArray.count {
//                print(laserArray[i].primaryKey)
//            }
        }
        else {
            hud.insuffEnergyDisplay(newEnergy: player.energy)
            if malfunctionTimer <= 0 {
                let laserMalfunction = SKAction.playSoundFileNamed("Sound/lasermalfunction.mp3", waitForCompletion: false)
                self.run(laserMalfunction)
            }
            malfunctionTimer = 2.25
        }
    }
    
    override func didSimulatePhysics() {
        self.camera!.position = player.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        // game over condition
        if player.health <= 0 && !gameOver {
            hud.showButtons()
            gameOver = true
            let loc = player.position
            
            // Explosions!!!
            for _ in 1...15 {
                let bits = Debris()
                bits.position = loc
                self.addChild(bits)
            }
            player.run(SKAction.removeFromParent())
        }
        
        // timer to keep track of spawns and resource regeneration
        if lastTime == nil {
            lastTime = currentTime
        }
        let elapsed = currentTime - lastTime!
        if !gameOver {
            player.energyRefreshRate -= elapsed
        }
        if player.energyRefreshRate <= 0 {
            if player.shielded {
                player.energy -= 4
                if player.energy < 50 {
                    
                    // shields power down
                    hud.insuffEnergyDisplay(newEnergy: player.energy)
                    player.shieldsDown()
                }
            }
            
            // energy regeneration rate
            player.energy += player.energyRegen
            if player.energy > 100 {
                player.energy = 100
            }
            player.energyRefreshRate = ENERGY_RECHARGE
        }
        
        // score increases longer player stays alive
        malfunctionTimer -= elapsed
        hud.scoreTickRate -= elapsed
        if hud.scoreTickRate <= 0 {
            hud.score += 3
            hud.scoreTickRate = SCORE_TICKRATE
        }
        
        // update timer
        lastTime = currentTime
        
        // update background
        for background in backgrounds {
            background.updatePosition(playerProgress_x: (player.position.x), playerProgress_y: (player.position.y))
        }
        
        // Check if player is out of bounds
        if map.inBounds(player: player) == false {
            map.outOfBoundsTimer -= elapsed
//            print(map.outOfBoundsTimer)
            player.energyRegen = 0
            if map.outOfBoundsTimer <= 0 {
                player.energy -= 2
                if player.energy <= 0 {
                    player.energy = 0
                    player.health -= 2
                }
                map.outOfBoundsTimer = OUT_OF_BOUNDS_TICK
            }
        } else {
            player.energyRegen = 2
            map.outOfBoundsTimer = 5
        }
        
        // ******* Core Motion code *******
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount: CGFloat
            var movement = CGVector()
            player.zRotation = CGFloat(atan2(-accelData.acceleration.x,accelData.acceleration.y)-Double(Double.pi/2))
            switch
            UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                forceAmount = 10
            case .landscapeRight:
                forceAmount = -10
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
            player.physicsBody?.applyForce(movement)
            
            // speed cap
            if (player.physicsBody?.velocity.dx)! > CGFloat(MAX_PLAYER_SPEED) {
                player.physicsBody?.velocity.dx = CGFloat(MAX_PLAYER_SPEED)
            }
            else if (player.physicsBody?.velocity.dx)! < CGFloat(-MAX_PLAYER_SPEED) {
                player.physicsBody?.velocity.dx = CGFloat(-MAX_PLAYER_SPEED)
            }
            if (player.physicsBody?.velocity.dy)! > CGFloat(MAX_PLAYER_SPEED) {
                player.physicsBody?.velocity.dy = CGFloat(MAX_PLAYER_SPEED)
            }
            else if (player.physicsBody?.velocity.dy)! < CGFloat(-MAX_PLAYER_SPEED) {
                player.physicsBody?.velocity.dy = CGFloat(-MAX_PLAYER_SPEED)
            }
            
            // update targeting indicator
            if let indicator = hud.indicator {
                indicator.alpha = 1
                hud.updateIndicator(target: opponent!, player: player)
            }
        }
        
        // **new condition to prevent score from increasing after game over
        if !gameOver{
            hud.setScoreDisplay(newScore: hud.score)
        }
        
        // update health and energy bars
        hud.setHealthDisplay(newHealth: player.health)
        hud.setEnergyDisplay(newEnergy: player.energy)
    }
    
}

// game constants
let ENERGY_RECHARGE = 0.1
let SCORE_TICKRATE = 2.0
let OUT_OF_BOUNDS_TICK = 0.2
let MAX_PLAYER_SPEED = 300
let MAX_PLAYER_HEALTH = 100

enum PhysicsCategory:UInt32 {
    case map = 0
    case spaceship = 2
    case damagedSpaceship = 4
    case enemy = 8
    case laser = 16
    case enemyLaser = 32
    case debris = 64
    case powerup = 128
    
    
}

//******* Player Collisions with Asteroid and Powerup ***********************
//
//        // asteroids and power ups disappear on collision
//        if other.node?.name != "Boss" {
//            other.node?.run(SKAction.removeFromParent())
//        }
//        rocks -= 1
//        for _ in 1...3 {
//            let bits = Debris()
//            bits.position = loc!
//            self.addChild(bits)
//        }
//
//        // powerup drifting spawn rate
//        if(arc4random_uniform(10) == 0) {
//            spawnPowerUp(location: loc!)
//        }
//        case PhysicsCategory.powerup.rawValue:
//            if let powertype = other.node?.name {
//                switch(powertype) {
//                case "healthpack":
//                    playerHealth += 1
//                    if playerHealth > MAX_PLAYER_HEALTH {
//                        playerHealth = MAX_PLAYER_HEALTH
//                    }
//                    break;
//                case "corrosive":
//                    let poisonSound = SKAction.playSoundFileNamed("Sound/poison.mp3", waitForCompletion: false)
//                    self.run(poisonSound)
//                    playerHealth -= 1
//                    player.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.2 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0.2 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1)]))
//                    break;
//
//
//                case "energy":
//                    energy += 50
//                    break;
//                default:
//                    break;
//            }
//            other.node?.run(SKAction.removeFromParent())
//      }
//****************************************************************************

//************ Boss, EnemyLaser, Asteroid Collisions with Player ***************
//
//    func playerCollision(other:SKPhysicsBody) {
//        switch other.categoryBitMask {
//        case PhysicsCategory.enemy.rawValue:
//        if player.shielded {
//            if other.node?.name == "bosslaser" {
//                energy -= 15
//            }
//            else {
//                energy -= 50
//            }
//
//        }
//        else {
//            playerHealth -= 1
//            let asteroidSound = SKAction.playSoundFileNamed("Sound/danger.mp3", waitForCompletion: false)
//            self.run(asteroidSound)
//            // boss contact = immediate death
//            if other.node?.name == "Boss" {
//                playerHealth -= 1
//            }
//            // player flashes on hit
//            player.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.2 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0.2 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1)]))
//
//
//        }
//        let loc = other.node?.position
//        default:
//            print("Unknown!")
//        }
//    }
//********************************************************************************

//**** Asteroid and Boss variables ********
//
//    var rockTimer = ROCK_SPAWNRATE
//    var rocks = 0
//    var bossInstance:Boss?
//    var bossSpawn: BossSpawnAnimation?
//    var bossTimer = 20.0
//    var bossSpawnTimer = 19.0
//    var bossSpawnPosition:CGPoint?
//    var bossBeamTimer = 4.5
//*****************************************

//****** Spawn Indicator when Boss spawns *********
//
//        if let boss = bossInstance {
//            if let indicator = hud.indicator {
//                indicator.alpha = 1
//                hud.updateIndicator(boss: boss, player: playerInstance as! Spaceship)
//            }
//        }
//*************************************************

//********* Asteroid and Boss Spawn Timers ***********************
//
//        // asteroid spawn timer
//        rockTimer -= elapsed
//        if rockTimer <= 0 {
//            addRock()
//            rockTimer = ROCK_SPAWNRATE-(0.2*(15-Double(rocks)))
//            if bossInstance != nil {
//                bossInstance!.beamSpam(scene: self)
//            }
//        }
//
//        bossBeamTimer -= elapsed
//        if bossBeamTimer <= 0 || bossBeamTimer > 0.24 && bossBeamTimer <= 0.25 || bossBeamTimer > 0.49 && bossBeamTimer <= 0.5 {
//            if bossInstance != nil {
//                bossInstance!.beamSpam(scene: self)
//                if bossBeamTimer <= 0 {
//                    bossBeamTimer = 4.5
//                }
//            }
//        }
//
//        // boss spawn animation
//        bossSpawnTimer -= elapsed
//        if bossSpawnTimer <= 0 {
//            bossSpawnPosition = CGPoint(x: (player.position.x)!, y: (player.position.y)! + 200)
//            if bossSpawn == nil {
//                bossSpawn = BossSpawnAnimation()
//                bossSpawn?.spawnAnimation()
//                print(bossSpawnPosition)
//                bossSpawn?.position = bossSpawnPosition!
//                self.addChild(bossSpawn!)
//            }
//            bossSpawnTimer = 59.0
//        }
//
//        // boss spawn timer
//        bossTimer -= elapsed
//        if bossTimer <= 0 {
//            if bossInstance != nil {
//            } else {
//                bossInstance = Boss()
//                print("Boss respawns.")
//                hud.addIndicator()
//                hud.addChild((hud.indicator!))
//                //                *******************************************
//                //                self.delegate.musicPlayer.volume = 0.0
//                //                let bossMusic = SKAction.playSoundFileNamed("Sound/bossmusic.mp3", waitForCompletion: false)
//                //                self.run(bossMusic, withKey: "bossbgm")
//                bossInstance?.health = 10
//                bossInstance?.position = bossSpawnPosition!
//                print("Added the indicator")
//                self.addChild(bossInstance!)
//            }
//            bossTimer = 60.0
//        }
//***********************************************************
    
//*********** Asteroid Spawn **************************
//
//    // asteroid spawn algorithm
//    func addRock() {
//        let rock = Asteroid()
//        repeat {
//
//            // randomly decide which side of screen to spawn
//            var x_mult:Double = 1
//            var y_mult:Double = 1
//            if arc4random_uniform(2) == 0 {
//                x_mult = -1
//            }
//            if arc4random_uniform(2) == 0 {
//                y_mult = -1
//            }
//            let rock_x = Double(playerInstance!.position.x)+x_mult*Double(arc4random_uniform(200)+100)
//            let rock_y = Double(playerInstance!.position.y)+y_mult*Double(arc4random_uniform(200)+100)
//            rock.position = CGPoint(x:rock_x, y:rock_y)
//
//            // generate safe dead zone around player
//        } while(abs(rock.position.x-playerInstance!.position.x) < 100 && abs(rock.position.y-playerInstance!.position.y) < 100)
//        self.addChild(rock)
//        // keep asteroid count
//        rocks += 1
//    }
//******************************************************

//***** Spawn Powerup function **********
//
//    func spawnPowerUp(location:CGPoint) {
//        let power = Powerup()
//        power.position = location
//        self.addChild(power)
//    }
//***************************************


//******** Laser Collision with Boss, Asteroid, and Powerup ******************
//
//    func laserCollision(laser: SKPhysicsBody, other:SKPhysicsBody) {
//        switch other.categoryBitMask {
//        case PhysicsCategory.enemy.rawValue:
//            if other.node?.name == "Boss" {
//                let boss = other.node as! Boss
//
//                // boss.loseHealth returns if boss is dead or not...rewards points accordingly
//                if boss.loseHealth(scene: self){
//                    if let deathSpawnNode = self.bossSpawn {
//                        deathSpawnNode.removeFromParent()
//                        self.bossSpawn = nil
//                    }
//                    if let deathNode = self.bossInstance {
//                        deathNode.removeFromParent()
//                        self.bossInstance = nil
//                    }
//                    hud.removeIndicator()
//                    hud.score += 100
//                }
//                laser.node?.run(SKAction.removeFromParent())
//            }
//            else {
//                let asteroidSound = SKAction.playSoundFileNamed("Sound/asteroid.mp3", waitForCompletion: false)
//                self.run(asteroidSound)
//                // laser collides with asteroid
//                hud.score += 10
//                laser.node?.run(SKAction.removeFromParent())
//                let loc = other.node?.position
//                other.node?.run(SKAction.removeFromParent())
//                rocks -= 1
//                for _ in 1...3 {
//                    let bits = Debris()
//                    bits.position = loc!
//                    self.addChild(bits)
//                }
//
//                // powerup spawn rate from breaking asteroid
//                if(arc4random_uniform(10) == 0) {
//                    spawnPowerUp(location: loc!)
//                }
//            }
//        default:
//            print("Unknown!")
//        }
//
//    }
//***************************************************************************

//******** func didBegin ****************************************************
//
//    func didBegin(_ contact: SKPhysicsContact){
//        let playerMask = PhysicsCategory.spaceship.rawValue | PhysicsCategory.damagedSpaceship.rawValue
//        let laserMask = PhysicsCategory.laser.rawValue
//        if (contact.bodyA.categoryBitMask & playerMask) > 0 {
//            playerCollision(other:contact.bodyB)
//        }
//        else if (contact.bodyA.categoryBitMask & laserMask) > 0 {
//            laserCollision(laser:contact.bodyA, other:contact.bodyB)
//        }
//        else {
//            if (contact.bodyB.categoryBitMask & playerMask) > 0 {
//                playerCollision(other:contact.bodyA)
//            }
//            else if (contact.bodyB.categoryBitMask & laserMask) > 0 {
//                laserCollision(laser:contact.bodyB, other: contact.bodyA)
//            }
//        }
//    }
//***************************************************************************

//******* Health/Energy Text ***************************
    // **no longer needed
//    hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
    // **no longer needed
//    hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
    // **no longer needed
//    hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
//    hud.energyText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
    // **no longer needed
//    hud.healthText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
    // **no longer needed
//    hud.healthText.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0 , duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0)]))
//*******************************************************
