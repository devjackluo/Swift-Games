//
//  GameViewController.swift
//  TapThatDonkey
//
//  Created by Zhaowen Luo on 7/12/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

let smallerView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))

class GameViewController: UIViewController, GADBannerViewDelegate{

    
    var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Created the banner ad
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        //bannerView.adSize = GADAdSize(size: CGSize(width: self.size.width, height: self.size.height) , flags: 1)
        bannerView.frame = CGRect(x: 0, y: view.frame.size.height-bannerView.frame.size.height, width: bannerView.frame.size.width, height: bannerView.frame.size.height)
        let banrequest = GADRequest()
        banrequest.testDevices = [ "437a52ae3fcded99fa9d6f6f9387e286", "63457f81415bc4a71391f2c96fba3d2b", kGADSimulatorID ]
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-1883187213556981/2282316559"
        //let bancurrentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
        //let banRC = self.view?.window?.rootViewController
        bannerView.rootViewController = self
        bannerView.load(banrequest)
        
        smallerView.addSubview(bannerView)
        
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            smallerView.backgroundColor = UIColor.clear
            smallerView.isHidden = true
            view.addSubview(smallerView)
            
            
            view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
        
        
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
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
