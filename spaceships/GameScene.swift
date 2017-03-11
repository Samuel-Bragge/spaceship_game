//
//  GameScene.swift
//  Spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Coding Dojo
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var playerInstance:SKSpriteNode?
    let playerSpeed:Double = 300
    let cam = SKCameraNode()
    var playerHealth = 10
    var score = 0
    var startTime = 0
    var lasttick = 0
    var rocks = 0
    var healthLabel:UILabel?
    var scoreLabel:UILabel?
    
    
    override func didMove(to view: SKView) {
        // Game Variables
        playerHealth = 10
        score = 0
        startTime = 0
        lasttick = 0
        rocks = 0
        // End Game Variables
        
        self.anchorPoint = .zero
        self.camera = cam
        self.physicsWorld.contactDelegate = self
        
        healthLabel = UILabel(frame: CGRect(x: 150, y: 0, width: 200, height: 21))
        healthLabel?.textAlignment = NSTextAlignment.center
        healthLabel?.text = "Health: \(playerHealth)"
        healthLabel?.textColor = .white
        self.view!.addSubview(healthLabel!)
        
        scoreLabel = UILabel(frame: CGRect(x: 25, y: 0, width: 200, height: 21))
        scoreLabel?.textAlignment = NSTextAlignment.left
        scoreLabel?.text = "Score: \(score)"
        scoreLabel?.textColor = .white
        self.view!.addSubview(scoreLabel!)
        
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
        if let firsttouch = touches.first {
            playerRespondToTouch(firstTouch: firsttouch)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firsttouch = touches.first {
            playerRespondToTouch(firstTouch: firsttouch)
        }
    }
    func playerRespondToTouch(firstTouch: UITouch) {
        if let me = playerInstance {
            let xDist: CGFloat = (firstTouch.location(in: self).x - me.position.x);
            let yDist: CGFloat = (firstTouch.location(in: self).y - me.position.y);
            let distance:Double = Double(hypotf(Float(xDist), Float(yDist)))
            let actionSequence = [SKAction.rotate(toAngle:atan2(yDist, xDist)-CGFloat(M_PI)/2, duration: 0.25, shortestUnitArc: true), SKAction.move(to:firstTouch.location(in: self), duration:distance/playerSpeed)]
            me.run(SKAction.group(actionSequence))
        }
    }
    
    override func didSimulatePhysics() {
        self.camera!.position = playerInstance!.position
        
    }
    override func update(_ currentTime: TimeInterval) {
        if startTime == 0 {
            startTime = Int(floor(currentTime))
            lasttick = Int(floor(currentTime))
        }
        if Int(floor(currentTime)) != lasttick {
            var ticked:Bool = false;
            if Int(floor(currentTime)) % 2 == 0 {
                score += 10
                ticked = true;
            }
            if Int(floor(currentTime)) % 5 == 0 {
                addRock()
                ticked = true
            }
            if ticked {
                lasttick = Int(floor(currentTime))
            }
        }
        scoreLabel?.text = "Score: \(score)"
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
            playerCollision(other:contact.bodyA)
        }
    }
    func playerCollision(other:SKPhysicsBody) {
        switch other.categoryBitMask {
        case PhysicsCategory.enemy.rawValue:
            playerHealth -= 1
            healthLabel?.text = "Health: \(playerHealth)"
            let loc = other.node?.position
            other.node?.run(SKAction.removeFromParent())
            rocks -= 1
            for _ in 1...3 {
                let bits = Debris()
                bits.position = loc!
                self.addChild(bits)
            }
        case PhysicsCategory.powerup.rawValue:
            print("Power up!")
        default:
            print("Unknown!")
        }
        
    }
    func laserCollision(laser: SKPhysicsBody, other:SKPhysicsBody) {
        switch other.categoryBitMask {
        case PhysicsCategory.enemy.rawValue:
            laser.node?.run(SKAction.removeFromParent())
            let loc = other.node?.position
            other.node?.run(SKAction.removeFromParent())
            rocks -= 1
            for _ in 1...3 {
                let bits = Debris()
                bits.position = loc!
                self.addChild(bits)
            }
        default:
            print("Unknown!")
        }
        
    }
}


enum PhysicsCategory:UInt32 {
    case spaceship = 1
    case damagedSpaceship = 2
    case enemy = 4
    case laser = 8
    case powerup = 16
    case debris = 32
}
