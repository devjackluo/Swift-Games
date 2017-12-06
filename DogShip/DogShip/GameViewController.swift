//
//  GameViewController.swift
//  DogShip
//
//  Created by Zhaowen Luo on 6/28/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false

        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill

        skView.presentScene(scene)

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
