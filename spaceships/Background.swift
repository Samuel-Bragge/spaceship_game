import SpriteKit

class Background: SKSpriteNode {
    // movementMultiplier will store a float from 0-1 to indicate
    // how fast the background should move past.
    // 0 is full adjustment, no movement as the world goes past
    // 1 is no adjustment, background passes at normal speed
    var movementMultiplier = CGFloat(1)
    // jumpAdjustment will store how many points of x position
    // this background has jumped forward, useful for calculating
    // future seamless jump points:
    var jumpAdjustment_x = CGFloat(0)
    var jumpAdjustment_y = CGFloat(0)
    // A constant for background node size:
    let backgroundSize = CGSize(width: 1024, height: 768)
    // Store the Backgrounds texture:
    var textureAtlas = SKTextureAtlas(named: "Backgrounds")
    
    func spawn(parentNode:SKNode, imageName:String,
               zPosition:CGFloat, movementMultiplier:CGFloat) {
        // Position from the bottom left:
        self.anchorPoint = CGPoint.zero
        // Start backgrounds at the top of the ground (y: 30)
        self.position = CGPoint(x: 0, y: 30)
        // Control the order of the backgrounds with zPosition:
        self.zPosition = zPosition
        // Store the movement multiplier:
        self.movementMultiplier = movementMultiplier
        // Add the background to the parentNode:
        parentNode.addChild(self)
        // Grab the texture for this background from the atlas:
        let texture = textureAtlas.textureNamed(imageName)
        
        // Build three child node instances of the texture,
        // Looping from -1 to 1 so the backgrounds cover both
        // forward and behind the player at position zero.
        // closed range operator: "..." includes both endpoints:
        for i in -1...1 {
            for j in -1...1 {
                let newBGNode = SKSpriteNode(texture: texture)
                // Set the size for this node from constant:
                newBGNode.size = backgroundSize
                // Position these nodes by their lower left corner:
                newBGNode.anchorPoint = CGPoint.zero
                // Position this background node:
                newBGNode.position = CGPoint(
                    x: i * Int(backgroundSize.width), y: j * Int(backgroundSize.height))
                // Add the node to the Background:
                self.addChild(newBGNode)
            }
        }
    }
    
    // We will call updatePosition every frame to
    // reposition the background:
    func updatePosition(playerProgress_x:CGFloat, playerProgress_y:CGFloat) {
        // Calculate a position adjustment after loops and
        // parallax multiplier:
        let adjustedPosition_x = jumpAdjustment_x + playerProgress_x *
            (1 - movementMultiplier)
        let adjustedPosition_y = jumpAdjustment_y + playerProgress_y * (1 - movementMultiplier)
        // Check if we need to jump the background forward:
        if playerProgress_x - adjustedPosition_x >
            backgroundSize.width {
            jumpAdjustment_x += backgroundSize.width
        }
        else if playerProgress_x - adjustedPosition_x < 0 {
            jumpAdjustment_x -= backgroundSize.width
        }
        if playerProgress_y - adjustedPosition_y > backgroundSize.height {
            jumpAdjustment_y += backgroundSize.height
        }
        else if playerProgress_y - adjustedPosition_y < 0 {
            jumpAdjustment_y -= backgroundSize.height
        }
        // Adjust this background forward as the world
        // moves back so the background appears slower:
        self.position.x = adjustedPosition_x
        self.position.y = adjustedPosition_y
    }
}
