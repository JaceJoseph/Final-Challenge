//
//  GameViewController.swift
//  IOSMoveSpritesAccelerometerTutorial
//
//  Created by Arthur Knopper on 18/12/2018.
//  Copyright © 2018 Arthur Knopper. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.doaSegue), name: NSNotification.Name(rawValue: "doaSegue"), object: nil)
        
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill

            // Present the scene
            gameView.presentScene(scene)
        }
            
        gameView.ignoresSiblingOrder = true
        }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func doaSegue(){
        performSegue(withIdentifier: "toFinish", sender: self)
        self.view.removeFromSuperview()
        self.view = nil
    }
}
