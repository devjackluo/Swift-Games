//
//  GameOverScene.swift
//  Clidor
//
//  Created by Zhaowen Luo on 7/8/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import SpriteKit
import GoogleMobileAds



class GameOverScene: SKScene, GADInterstitialDelegate{
    
    var restartBTN: SKSpriteNode!
    var Highscore : Int!
    var ScoreLbl : UILabel!
    var HighscoreLbl : UILabel!
    var ScoreTxt : UILabel!
    var HighscoreTxt : UILabel!
    var Score: Int!
    
    var interstitialAd: GADInterstitial?
    var createRand:UInt32!
    
    //var bannerView: GADBannerView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        

        
        //anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        

        
        smallerView.isHidden = false
        
        

        
        

        //let gVC = GameViewController()
        //gVC.showAd()
        
        
        self.backgroundColor = SKColor.black
        
        let backTexture = SKTexture(imageNamed: "meadow.png")
        let backgroundM = SKSpriteNode(texture: backTexture, size: CGSize(width: self.frame.width, height: self.size.height))
        backgroundM.position = CGPoint(x: self.frame.width/2, y: self.size.height/2)
        backgroundM.zPosition = -25
        self.addChild(backgroundM)
        
        
        
        createRand = arc4random_uniform(3)
        if createRand == 1 {
            interstitialAd = createAndLoadInterstitial()
        }
        
        
        let ScoreDefault = UserDefaults.standard
        if(ScoreDefault.value(forKey: "Score") != nil){
            Score = ScoreDefault.value(forKey: "Score") as! NSInteger
        }else{
            Score = 0
        }
        
        let HighscoreDefault = UserDefaults.standard
        if(HighscoreDefault.value(forKey: "Highscore") != nil){
            Highscore = HighscoreDefault.value(forKey: "Highscore") as! NSInteger
        }else{
            Highscore = 0
        }
        
        let ScoreLbl = SKLabelNode(fontNamed: "Cartoon Relief")
        ScoreLbl.text = "\(Score!)"
        ScoreLbl.fontColor = UIColor(red:1.00, green:0.46, blue:0.07, alpha:1.0)
        ScoreLbl.fontSize = self.size.height/20
        ScoreLbl.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + self.size.height/6 - self.size.height/16)
        addChild(ScoreLbl)
        
        let ScoreTxt = SKLabelNode(fontNamed: "Cartoon Relief")
        ScoreTxt.text = "Your Score"
        ScoreTxt.fontColor = UIColor(red:1.00, green:0.46, blue:0.07, alpha:1.0)
        ScoreTxt.fontSize = self.size.height/20
        ScoreTxt.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + self.size.height/6)
        addChild(ScoreTxt)
        
        
        
        
        let HighscoreLbl = SKLabelNode(fontNamed: "Cartoon Relief")
        HighscoreLbl.text = "\(Highscore!)"
        HighscoreLbl.fontColor = UIColor(red:1.00, green:0.05, blue:0.28, alpha:1.0)
        HighscoreLbl.fontSize = self.size.height/20
        HighscoreLbl.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + self.size.height/3 - self.size.height/16)
        addChild(HighscoreLbl)
        
        let HighscoreTxt = SKLabelNode(fontNamed: "Cartoon Relief")
        HighscoreTxt.text = "Highscore"
        HighscoreTxt.fontColor = UIColor(red:1.00, green:0.05, blue:0.28, alpha:1.0)
        HighscoreTxt.fontSize = self.size.height/20
        HighscoreTxt.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + self.size.height/3)
        addChild(HighscoreTxt)
        
        
        
        
        
        createBTN()
        
        
        
        
        
        
    }
    
 

   
    
    func createBTN(){
        
        restartBTN = SKSpriteNode(imageNamed: "replay.png")
        restartBTN.size = CGSize(width: self.size.width/2, height: self.size.width/4)
        restartBTN.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - self.size.height/8)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        restartBTN.run(SKAction.scale(to: 1.0, duration: 0.2))
        
    }
    
    
    
    func Restart(){
        
        if createRand == 1 {
            
            self.showAd()
            
        }else{
            
            self.restartGame()
        }
        
        
    }
    
    func restartGame(){
        
        smallerView.isHidden = true
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            
            if restartBTN.contains(location){
                Restart()
            }
            
            
        }
        
        
    }
    
    
    func showAd() {
        if interstitialAd != nil{
            if interstitialAd!.isReady{
                let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
                interstitialAd?.present(fromRootViewController: currentViewController)
            }else{
                //print("fail")
                self.restartGame()
            }
        }else{
            //print("fail")
            self.restartGame()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        request.testDevices = [ "437a52ae3fcded99fa9d6f6f9387e286", "63457f81415bc4a71391f2c96fba3d2b", kGADSimulatorID ]
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1883187213556981/6287040556")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.restartGame()
    }
    
    
    
    
    
    
}
