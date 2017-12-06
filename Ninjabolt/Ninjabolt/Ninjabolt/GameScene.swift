//
//  GameScene.swift
//  Bolting Ninja
//
//  Created by Zhaowen Luo on 6/22/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate, GADInterstitialDelegate {
    
    var movingGround: ZLMovingGround!
    var hero: ZLHero!
    var cloudGenerator: ZLCloudGenerator!
    var wallGenerator: ZLWallGenerator!
    var isStarted: Bool = false
    var isGameOver: Bool = false
    var currentLevel: Int = 0
    var pauseButton: SKSpriteNode! = nil
    var highscoreLabel = ZLPointsLabel(num: 0)
    var highscoreTextLabel = SKLabelNode()
    var charlieModeOn: Bool = false
    var charlieModeWallSpeed: Double = 1600.0
    var groundHeight: CGFloat = 20.0
    var interstitialAd: GADInterstitial?
    var createRand:UInt32!
    
    override func didMove(to view: SKView) {
        
        createRand = arc4random_uniform(3)
        if createRand == 1 {
            do{
                try interstitialAd = createAndLoadInterstitial()
            }
        }
        
        
        backgroundColor = UIColor(red: 150.0/255.0, green: 202.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        groundHeight = self.frame.height/16
        customBackground()
        addMovingGround()
        addHero()
        addCloudGenerator()
        addWallGenerator()
        addTapToStartLabel()
        charlieCrazy()
        addPhysicsWorld()
    }
    
    func charlieCrazy(){
        let charlieBtn = SKLabelNode(text: "Insane Mode")
        charlieBtn.name = "charlieLbl"
        charlieBtn.position.y = charlieBtn.position.y - charlieBtn.frame.size.height/2 - charlieBtn.frame.size.height/4 - charlieBtn.frame.size.height
        charlieBtn.fontName = "Helvetica"
        charlieBtn.fontColor = UIColor.black
        charlieBtn.fontSize = groundHeight*2.0
        charlieBtn.zPosition = 10
        
        let redTexture = SKTexture(imageNamed: "redbtn.png")
        let redBtn = SKSpriteNode(texture: redTexture, size: CGSize(width: charlieBtn.frame.size.width*1.2, height: charlieBtn.frame.size.height*1.5))
        redBtn.position.x = self.size.width/2
        redBtn.position.y = self.size.height/2 - self.size.height/4
        redBtn.name = "charlieBtn"
        addChild(redBtn)
        redBtn.addChild(charlieBtn)
        charlieBtn.run(blinkAnimation())
    }
    
    func customBackground(){
        let backgroundTexture = SKTexture(imageNamed: "cloud-bg.jpeg")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture, size: self.frame.size)
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.zPosition = -5
        addChild(backgroundImage)
    }
    
    func addMovingGround(){
        movingGround = ZLMovingGround(size: CGSize(width: self.frame.width, height: groundHeight))
        movingGround.position = CGPoint(x: 0, y: self.frame.size.height/2)
        addChild(movingGround)
    }
    
    func addHero(){
        hero = ZLHero(gHeight: groundHeight)
        hero.position = CGPoint(x: self.size.width/5, y: movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breathe()
    }
    
    func addCloudGenerator(){
        cloudGenerator = ZLCloudGenerator(color: UIColor.clear, size: self.frame.size)
        cloudGenerator.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(cloudGenerator)
        cloudGenerator.populate(num: 7, cloudW: self.frame.width/4, cloudH: self.frame.height/7)
        cloudGenerator.startGeneratingWithSpawnTime(seconds: 5)
    }
    
    func addWallGenerator(){
        wallGenerator = ZLWallGenerator(color: UIColor.clear, size: self.frame.size)
        wallGenerator.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(wallGenerator)
    }
    
    func addTapToStartLabel(){
        
        let tapToStartLabel = SKLabelNode(text: "Classic Mode")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.y = tapToStartLabel.position.y - tapToStartLabel.frame.size.height - tapToStartLabel.frame.size.height/2 - tapToStartLabel.frame.size.height/4
        //tapToStartLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = UIColor.black
        tapToStartLabel.fontSize = groundHeight*2.0
        tapToStartLabel.zPosition = 10
        
        let greenTexture = SKTexture(imageNamed: "greenbtn.png")
        let greenBtn = SKSpriteNode(texture: greenTexture, size: CGSize(width: tapToStartLabel.frame.size.width*1.2, height: tapToStartLabel.frame.size.height*1.5))
        greenBtn.position.x = self.size.width/2
        greenBtn.position.y = self.size.height/2 + self.frame.size.height/4
        greenBtn.name =  "tapToStartBtn"
        addChild(greenBtn)
        
        
        
        
        
        
        
        greenBtn.addChild(tapToStartLabel)
        tapToStartLabel.run(blinkAnimation())
    }
    
    
    func addPointsLabels(){
        
        let pointsLabel = ZLPointsLabel(num: 0)
        pointsLabel.position = CGPoint(x: self.frame.size.width/15 , y: self.frame.size.height - self.frame.size.width/15)
        pointsLabel.name = "pointsLabel"
        pointsLabel.fontColor = UIColor.blue
        pointsLabel.fontSize = 50
        addChild(pointsLabel)
        
        
    }
    
    func loadHighscore(){
        addPointsLabels()
        highscoreLabel.name = "highscoreLabel"
        highscoreLabel.position = CGPoint(x: self.frame.size.width - self.frame.size.width/15, y: self.frame.size.height - self.frame.size.width/15)
        highscoreLabel.fontSize = 50
        addChild(highscoreLabel)
        
        highscoreTextLabel = SKLabelNode(text: "Best")
        highscoreTextLabel.fontColor = UIColor.yellow
        highscoreTextLabel.fontSize = 50
        highscoreTextLabel.fontName = "Helvetica"
        highscoreTextLabel.position = CGPoint(x: 0, y: -self.frame.size.width/20)
        highscoreLabel.addChild(highscoreTextLabel)
        if charlieModeOn == true {
            let defaults = UserDefaults.standard
            let highscoreLabel = childNode(withName: "highscoreLabel") as! ZLPointsLabel
            highscoreLabel.setTo(num: defaults.integer(forKey: "highscoreCharlie"))
        }else {
            let defaults = UserDefaults.standard
            let highscoreLabel = childNode(withName: "highscoreLabel") as! ZLPointsLabel
            highscoreLabel.setTo(num: defaults.integer(forKey: "highscore"))
        }
    }
    
    func addPhysicsWorld(){
        physicsWorld.contactDelegate = self
    }
    
    func start(){
        isStarted = true
        let tapToStartLabel = childNode(withName: "tapToStartBtn")
        tapToStartLabel?.removeFromParent()
        let charlieLabel = childNode(withName: "charlieBtn")
        charlieLabel?.removeFromParent()
        hero.stop()
        hero.startRunning()
        movingGround.start()
        wallGenerator.startGeneratingWallsEvery(seconds: kLevelGenerationTimes[currentLevel], gHeight: groundHeight)
    }
    
    func startCharlie(){
        charlieModeOn = true
        isStarted = true
        let tapToStartLabel = childNode(withName: "tapToStartBtn")
        tapToStartLabel?.removeFromParent()
        let charlieLabel = childNode(withName: "charlieBtn")
        charlieLabel?.removeFromParent()
        hero.stop()
        hero.startRunning()
        movingGround.startCharlie(groundSpeed: charlieModeWallSpeed)
        wallGenerator.startGeneratingWallsCharlieMode(charlie: true, wallSpeed: charlieModeWallSpeed, gHeight: groundHeight)
    }
    func gameOver(){
        isGameOver = true
        hero.fall()
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        let gameOverLabel = SKSpriteNode(color: UIColor.clear, size: CGSize(width: self.frame.size.width/4, height: self.frame.size.height/10))
        gameOverLabel.position.x = self.size.width/2
        gameOverLabel.position.y = self.size.height/2 + self.frame.size.height/4
        let gameoverTexture:SKTexture
        gameoverTexture = SKTexture(imageNamed: "gameover.png")
        gameoverTexture.filteringMode = SKTextureFilteringMode.nearest
        gameOverLabel.texture = gameoverTexture
        addChild(gameOverLabel)
        gameOverLabel.run(blinkAnimation())
        let restartButton = SKSpriteNode(color: UIColor.clear, size: CGSize(width: self.frame.size.width/6, height: self.frame.size.width/6))
        restartButton.position.x = self.size.width/2
        restartButton.position.y = self.size.height/2 - self.frame.size.height/4
        restartButton.name = "restartButton"
        let restartTexture:SKTexture
        restartTexture = SKTexture(imageNamed: "restart.png")
        restartTexture.filteringMode = SKTextureFilteringMode.nearest
        restartButton.texture = restartTexture
        addChild(restartButton)
        let pointsLabel = childNode(withName: "pointsLabel") as! ZLPointsLabel
        let highscoreLabel = childNode(withName: "highscoreLabel") as! ZLPointsLabel
        if highscoreLabel.number < pointsLabel.number{
            if charlieModeOn == true {
                highscoreLabel.setTo(num: pointsLabel.number)
                let defaults = UserDefaults.standard
                defaults.set(highscoreLabel.number, forKey: "highscoreCharlie")
            }else {
                highscoreLabel.setTo(num: pointsLabel.number)
                let defaults = UserDefaults.standard
                defaults.set(highscoreLabel.number, forKey: "highscore")
            }
        }
    }
    
    func Restart(){
        
        if createRand == 1 {
            
            self.showAd()
            
        }else{
            
            self.restartGame()
        }
        
        
    }
    
    func restartGame(){
        cloudGenerator.stopGenerating()
        let newScene = GameScene(size: self.size)
        //newScene.scaleMode = .aspectFill
        self.view!.presentScene(newScene)
        
        /*let transition = SKTransition.fade(withDuration: 0.5)
         let gameScene = GameScene(size: self.size)
         self.view?.presentScene(gameScene, transition: transition)*/
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver{
            for touch in touches {
                let location = touch.location(in: self)
                let node:SKNode = self.atPoint(location)
                if(node.name == "restartButton"){
                    self.Restart()
                }
            }
        }else if !isStarted {
            for touch in touches {
                let location = touch.location(in: self)
                let node:SKNode = self.atPoint(location)
                if(node.name == "charlieLbl" || node.name == "charlieBtn"){
                    startCharlie()
                    loadHighscore()
                    highscoreTextLabel.fontColor = UIColor.red
                    highscoreLabel.fontColor = UIColor.red
                }else if (node.name == "tapToStartLabel" || node.name == "tapToStartBtn"){
                    start()
                    loadHighscore()
                }
            }
        }else{
            hero.flip()
        }
    }
    
    override func update(_ currentTime: CFTimeInterval){
        if wallGenerator.wallTrackers.count > 0{
            let wall = wallGenerator.wallTrackers[0] as ZLWall
            let wallLocation = wallGenerator.convert(wall.position, to: self)
            if wallLocation.x < hero.position.x-hero.size.width {
                wallGenerator.wallTrackers.remove(at: 0)
                wallGenerator.walls.remove(at: 0)
                let pointsLabel = childNode(withName: "pointsLabel") as! ZLPointsLabel
                pointsLabel.increment()
                if charlieModeOn == true {
                    if pointsLabel.number % 3 == 0 && pointsLabel.number < 29{
                        wallGenerator.stopGenerating()
                        charlieModeWallSpeed += 80.0
                        wallGenerator.startGeneratingWallsCharlieMode(charlie: true, wallSpeed: charlieModeWallSpeed, gHeight: groundHeight)
                        movingGround.stop()
                        movingGround.startCharlie(groundSpeed: charlieModeWallSpeed)
                    }else if pointsLabel.number % 6 == 0 && pointsLabel.number < 89 && pointsLabel.number > 29{
                        wallGenerator.stopGenerating()
                        charlieModeWallSpeed += 60.0
                        wallGenerator.startGeneratingWallsCharlieMode(charlie: true, wallSpeed: charlieModeWallSpeed, gHeight: groundHeight)
                        movingGround.stop()
                        movingGround.startCharlie(groundSpeed: charlieModeWallSpeed)
                    }else if pointsLabel.number % 10 == 0 && pointsLabel.number > 89{
                        wallGenerator.stopGenerating()
                        charlieModeWallSpeed += 40.0
                        wallGenerator.startGeneratingWallsCharlieMode(charlie: true, wallSpeed: charlieModeWallSpeed, gHeight: groundHeight)
                        movingGround.stop()
                        movingGround.startCharlie(groundSpeed: charlieModeWallSpeed)
                    }
                    
                    //print("\(charlieModeWallSpeed)")
                    
                }else{
                    if pointsLabel.number % 4 == 0 && pointsLabel.number < 39{
                        currentLevel += 1
                        wallGenerator.stopGenerating()
                        wallGenerator.startGeneratingWallsEvery(seconds: kLevelGenerationTimes[currentLevel], gHeight: groundHeight)
                    }else if pointsLabel.number % 10 == 0 && pointsLabel.number < 79 && pointsLabel.number > 39{
                        currentLevel += 1
                        wallGenerator.stopGenerating()
                        wallGenerator.startGeneratingWallsEvery(seconds: kLevelGenerationTimes[currentLevel], gHeight: groundHeight)
                    }else if pointsLabel.number % 20 == 0 && pointsLabel.number > 79 {
                        currentLevel += 1
                        wallGenerator.stopGenerating()
                        wallGenerator.startGeneratingWallsEvery(seconds: kLevelGenerationTimes[currentLevel], gHeight: groundHeight)
                    }
                    
                    //print("\(kLevelGenerationTimes[currentLevel])")
                    
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        if !isGameOver{
            gameOver()
        }
    }
    
    func blinkAnimation() -> SKAction{
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
    }
    
    
    
    func showAd() {
        if interstitialAd != nil{
            if interstitialAd!.isReady{
                let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
                interstitialAd?.present(fromRootViewController: currentViewController)
            }else{
                print("fail")
                self.restartGame()
            }
        }else{
            print("fail")
            self.restartGame()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        request.testDevices = [ "437a52ae3fcded99fa9d6f6f9387e286", "63457f81415bc4a71391f2c96fba3d2b", kGADSimulatorID ]
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1883187213556981/9005651353")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.restartGame()
    }
    
    
}
