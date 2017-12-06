//
//  EndScene.swift
//  DogShip
//
//  Created by Zhaowen Luo on 6/28/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

class EndScene : SKScene, GADInterstitialDelegate {

    var RestartBtn: UIButton!
    var Highscore : Int!
    var ScoreLbl : UILabel!
    var HighscoreLbl : UILabel!
    var ScoreTxt : UILabel!
    var HighscoreTxt : UILabel!
    var Score: Int!
    
    var interstitialAd: GADInterstitial?
    
    var staticViewSize: CGFloat = 20.0
    
    override func didMove(to view: SKView) {
        
        interstitialAd = createAndLoadInterstitial()
        
        staticViewSize = view.frame.height/16
        
        scene?.backgroundColor = UIColor.gray
        
        RestartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: view.frame.size.width/8))
        RestartBtn.backgroundColor = UIColor(red:0.07, green:0.35, blue:0.04, alpha:1.0)
        RestartBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2 + view.frame.size.height/10)
        
        
        RestartBtn.setTitle("Restart", for: UIControlState())
        RestartBtn.setTitleColor(UIColor.white, for: UIControlState())
        RestartBtn.titleLabel!.font =  UIFont.boldSystemFont(ofSize: staticViewSize/2)
        RestartBtn.addTarget(self, action: #selector(self.Restart), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(RestartBtn)
        
        
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

        ScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: staticViewSize))
        ScoreLbl.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/3 + view.frame.size.height/20)
        ScoreLbl.text = "\(Score!)"
        ScoreLbl.font = ScoreLbl.font.withSize(staticViewSize/2)
        ScoreLbl.textAlignment = NSTextAlignment.center
        self.view?.addSubview(ScoreLbl)
        
        ScoreTxt = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: staticViewSize))
        ScoreTxt.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/3)
        ScoreTxt.text = "Your Score"
        ScoreTxt.font = ScoreTxt.font.withSize(staticViewSize/2)
        ScoreTxt.textAlignment = NSTextAlignment.center
        self.view?.addSubview(ScoreTxt)
    
        HighscoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: staticViewSize))
        HighscoreLbl.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/4)
        HighscoreLbl.text = "\(Highscore!)"
        HighscoreLbl.font = HighscoreLbl.font.withSize(staticViewSize/2)
        HighscoreLbl.textAlignment = NSTextAlignment.center
        self.view?.addSubview(HighscoreLbl)
        
        HighscoreTxt = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: staticViewSize))
        HighscoreTxt.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/4 - view.frame.size.height/20)
        HighscoreTxt.text = "Highscore"
        HighscoreTxt.font = HighscoreTxt.font.withSize(staticViewSize/2)
        HighscoreTxt.textAlignment = NSTextAlignment.center
        self.view?.addSubview(HighscoreTxt)
        
        
        
    }
    
    func Restart(){

        let rand = arc4random_uniform(3)
        if rand == 1 {
            self.showAd()
        }else{
            self.gameReturn()
        }
    }

    func gameReturn(){
    
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene, transition: SKTransition.crossFade(withDuration: 0.3))
        
        RestartBtn.removeFromSuperview()
        ScoreLbl.removeFromSuperview()
        HighscoreLbl.removeFromSuperview()
        ScoreTxt.removeFromSuperview()
        HighscoreTxt.removeFromSuperview()
        
    }
    
    
    func showAd() {
        if interstitialAd != nil{
            if interstitialAd!.isReady{
                let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
                interstitialAd?.present(fromRootViewController: currentViewController)
            }else{
                self.gameReturn()
            }
        }else{
            self.gameReturn()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        request.testDevices = [ "437a52ae3fcded99fa9d6f6f9387e286", kGADSimulatorID ]
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1883187213556981/6057028154")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.gameReturn()
    }

    
    
}
