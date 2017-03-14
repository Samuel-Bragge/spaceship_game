//
//  GameViewController.swift
//  spaceships
//
//  Created by Justin Chang on 3/11/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    var musicPlayer = AVAudioPlayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if UserDefaults.standard.object(forKey: "hiscore") == nil {
            UserDefaults.standard.set(0, forKey: "hiscore")
            UserDefaults.standard.synchronize()
        }
        let menuScene = MenuScene()
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        menuScene.size = view.bounds.size
        skView.presentScene(menuScene)
//         Start the background music:
        if let musicPath = Bundle.main.path(forResource:
            "Sound/BackgroundMusic.mp3", ofType: nil) {
            let url = URL(fileURLWithPath: musicPath)
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer.numberOfLoops = -1
                musicPlayer.prepareToPlay()
                musicPlayer.play()
                musicPlayer.volume = 0.7
            }
            catch { /* Couldn't load music file */ }
        }
        
        //        if let view = self.view as! SKView? {
        //            // Load the SKScene from 'GameScene.sks'
        //            if let scene = SKScene(fileNamed: "GameScene") {
        //                // Set the scale mode to scale to fit the window
        //                scene.scaleMode = .aspectFill
        //                // Size our scene to fit the view exactly:
        //                scene.size = view.bounds.size
        //                // Show the new scene:
        //                view.presentScene(scene)
        //            }
        //
        //            view.ignoresSiblingOrder = true
        //            view.showsFPS = true
        //            view.showsNodeCount = true
        //        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

