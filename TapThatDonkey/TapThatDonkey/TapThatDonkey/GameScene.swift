//
//  GameScene.swift
//  TapThatDonkey
//
//  Created by Zhaowen Luo on 7/12/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var sounds = Int()
    
    var donkeyGenerator: ZLDonkeyGenerator!
    
    var ScoreLbl = SKLabelNode()
    var Score: Int = 0
    
    var howManyLives = Int()
    var livesLeft = SKSpriteNode()
    
    var scoreBar = SKSpriteNode()
    
    var backgroundRed = SKSpriteNode()
    
    func blinkAnimationBg() -> SKAction{
        let duration = 0.1
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 0.5, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn, fadeOut])
        return SKAction.sequence([blink, blink, blink, blink, blink])
    }
    
    override func didMove(to view: SKView) {
        
        let HighscoreDefault = UserDefaults.standard
        if(HighscoreDefault.value(forKey: "Highscore") != nil){
            Highscore = HighscoreDefault.value(forKey: "Highscore") as! NSInteger
        }else{
            Highscore = 0
        }
        
        let soundDefault = UserDefaults.standard
        if(soundDefault.value(forKey: "Sound") != nil){
            sounds = soundDefault.value(forKey: "Sound") as! NSInteger
        }else{
            sounds = 0
        }
        
        howManyLives = 2
        
        physicsWorld.contactDelegate = self
        
        
        backgroundRed = SKSpriteNode(color: UIColor.red, size: CGSize(width: self.frame.width, height: self.size.height))
        backgroundRed.position = CGPoint(x: self.frame.width/2, y: self.size.height/2)
        backgroundRed.alpha = 0
        backgroundRed.zPosition = -20
        self.addChild(backgroundRed)
        
        
        let backTexture = SKTexture(imageNamed: "meadow.png")
        let backgroundM = SKSpriteNode(texture: backTexture, size: CGSize(width: self.frame.width, height: self.size.height))
        backgroundM.position = CGPoint(x: self.frame.width/2, y: self.size.height/2)
        backgroundM.zPosition = -25
        self.addChild(backgroundM)
        
        
        
        
        scoreBar = SKSpriteNode(color: UIColor.orange, size: CGSize(width: self.frame.width, height: 100))
        scoreBar.position = CGPoint(x: self.frame.width/2, y: self.size.height-scoreBar.size.height/2)
        self.addChild(scoreBar)
        
        ScoreLbl.position.y = ScoreLbl.position.y - 35
        ScoreLbl.position.x = -self.size.width/2 + 125
        ScoreLbl.text = "\(Score)"
        ScoreLbl.fontName = "Cartoon Relief"
        ScoreLbl.zPosition = 5
        ScoreLbl.fontSize = self.frame.width/12*1.2
        ScoreLbl.isHidden = true
        scoreBar.addChild(ScoreLbl)
        
        
        
        livesLeft.size = CGSize(width: 100, height: 100)
        //livesLeft.position = CGPoint(x: (self.frame.width-CGFloat(howManyLives)*100)-20,y: self.frame.height-100)
        livesLeft.position.x = (self.size.width/2-CGFloat(howManyLives)*100)-20
        livesLeft.position.y = livesLeft.position.y - 50
        //livesLeft.alpha = 0.5
        
        for i in 0..<howManyLives {
            
            let heart = SKSpriteNode(imageNamed: "heartlives.png")
            heart.size = CGSize(width: 100, height: 100)
            heart.anchorPoint = CGPoint.zero
            heart.position = CGPoint(x: CGFloat(i)*heart.frame.width, y: 0)
            livesLeft.addChild(heart)
            
        }
        
        livesLeft.isHidden = true
        scoreBar.addChild(livesLeft)
        
        
        addTapToStartLabel()
        
        addLives()
        changeDonkey()
        
        createSounds()
        
        if sounds == 0 {
            
            backgroundMusicPlayer.play()
            
        }
        
        createSoundBtn()
        
        //addDonkeyGenerator()
        
    }
    
    
    func refreshLives(){
        
        livesLeft.removeAllChildren()
        
        /*
        donkeyGenerator.enumerateChildNodes(withName: "donkeyAir", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))
        
        
        donkeyGenerator.enumerateChildNodes(withName: "camel", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))
        
        donkeyGenerator.enumerateChildNodes(withName: "donkeyAlive", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))
        
        donkeyGenerator.enumerateChildNodes(withName: "life", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))*/
        
        
        
        
    
        livesLeft.removeFromParent()
        

        //print("\(howManyLives)")
        
        livesLeft.size = CGSize(width: 100, height: 100)
        //livesLeft.position = CGPoint(x: (self.frame.width-CGFloat(howManyLives)*100)-20,y: self.frame.height-100)
        if howManyLives == 1{
            livesLeft.position.x = (self.size.width/2-CGFloat(1)*100)-20
        }else{
            livesLeft.position.x = (self.size.width/2-CGFloat(howManyLives)*100)-20
        }
        livesLeft.position.y = ScoreLbl.position.y - 15
        //livesLeft.alpha = 0.5
        
        if howManyLives == 1{
            
            
            
            
            let heart = SKSpriteNode(imageNamed: "heartlives.png")
            heart.name = "heart"
            heart.size = CGSize(width: 100, height: 100)
            heart.anchorPoint = CGPoint.zero
            heart.position = CGPoint(x: 0, y: 0)
            livesLeft.addChild(heart)
                
            
            
            scoreBar.addChild(livesLeft)
            
        }else if howManyLives != 0{
        
            for i in 0..<howManyLives {
                
                let heart = SKSpriteNode(imageNamed: "heartlives.png")
                heart.name = "heart"
                heart.size = CGSize(width: 100, height: 100)
                heart.anchorPoint = CGPoint.zero
                heart.position = CGPoint(x: CGFloat(i)*heart.frame.width, y: 0)
                livesLeft.addChild(heart)
                
            }
            
            scoreBar.addChild(livesLeft)
        }
        
        

        
        
        if howManyLives <= 0 {
            noMoreLives()
        }
    
    }

    
    
    
    func addDonkeyGenerator(){
        donkeyGenerator = ZLDonkeyGenerator(color: UIColor.clear, size: self.frame.size)
        donkeyGenerator.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(donkeyGenerator)
        donkeyGenerator.startGeneratingWithSpawnTime(seconds: donkeySpawn)
    }
    
    
    /*
     func restartGame(){
     
     donkeyGenerator.stopGenerating()
     }*/
    
    var gameStarted = Bool()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        for touch in touches {
            
            let location = touch.location(in: self)
            let node:SKNode = self.atPoint(location)
            
            if(node.name == "soundOn"){
                
                let soundSet:Int = 1
                let defaults = UserDefaults.standard
                defaults.set(soundSet, forKey: "Sound")
                node.removeFromParent()
                createSoundBtn()
                backgroundMusicPlayer.stop()
                
            }else if (node.name == "soundOff"){
                
                let soundSet:Int = 0
                let defaults = UserDefaults.standard
                defaults.set(soundSet, forKey: "Sound")
                node.removeFromParent()
                createSoundBtn()
                backgroundMusicPlayer.play()
                
                
                
            }else{
                
                
                
                if gameStarted == false{
                    
                    gameStarted = true
                    
                    let tapToStartLabel = childNode(withName: "tapToStartLabel")
                    tapToStartLabel?.removeFromParent()

                    soundBtn.removeFromParent()
                    
                    ScoreLbl.isHidden = false
                    livesLeft.isHidden = false
                    
                    addDonkeyGenerator()
 
                }else{
                
                    
                    if(node.name == "donkeyAlive")||(node.name == "donkeyAir"){
                        node.removeFromParent()
                        
                        Score += 1
                        ScoreLbl.text = "\(Score)"
                        
                    }else if (node.name == "life"){
                        
                        //node.removeFromParent()
                        //self.backgroundColor = UIColor.red
                        
                        node.removeFromParent()

                        if howManyLives <= 4 {
                            
                            backgroundRed.color = UIColor.green
                            backgroundRed.run(blinkAnimationBg())
                            howManyLives += 1
                            refreshLives()
                            
                        }else{
                        
                            backgroundRed.color = UIColor.yellow
                            backgroundRed.run(blinkAnimationBg())
                            donkeyGenerator.removeAllChildren()
                        
                        }
                        
                        
                        
                    }else if (node.name == "camel"){
                        
                        //node.removeFromParent()
                        //self.backgroundColor = UIColor.red
                        
                        node.removeFromParent()
                        backgroundRed.color = UIColor.red
                        backgroundRed.run(blinkAnimationBg())
                        
                        howManyLives -= 1
                        
                        donkeyGenerator.removeAllChildren()
                        
                        refreshLives()
                        //removeLive()
                    }

                
                }
                
                
            }
            
        }
        
        
        /*
        for touch in touches {
            let location = touch.location(in: self)
            let node:SKNode = self.atPoint(location)
            if(node.name == "donkeyAlive")||(node.name == "donkeyAir"){
                node.removeFromParent()
                
                Score += 1
                ScoreLbl.text = "\(Score)"
                
            }else if (node.name == "camel"){
                print("hit camel")
                //node.removeFromParent()
                //self.backgroundColor = UIColor.red
                
                node.removeFromParent()
                backgroundRed.run(blinkAnimationBg())
                
                
                removeLive()
                
            }
        }*/
        
    }
    
    
    
    func changeDonkey(){
        
        //print("safasfsa")
        
        let changeNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: self.frame.width*2, height: 1))

        changeNode.name = "changeNode"
        changeNode.position = CGPoint(x: self.frame.width/2, y: 400)
        changeNode.physicsBody = SKPhysicsBody(rectangleOf: changeNode.size)
        
        
        changeNode.physicsBody?.affectedByGravity = false
        changeNode.physicsBody?.isDynamic = true
        changeNode.physicsBody?.categoryBitMask = changeCategory
        changeNode.physicsBody?.collisionBitMask = 0
        changeNode.physicsBody?.contactTestBitMask = donkeyCategory
        changeNode.zPosition = 15
        
        self.addChild(changeNode)
        
        
    }
    
    
    
    func addLives(){
        
        //print("safasfsasfsafasa")
        
        let liveNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: self.frame.width*2, height: 1))
        //liveNode.size = CGSize(width: self.frame.width, height: 1)
        //liveNode.color = UIColor.black
        liveNode.name = "liveNode"
        liveNode.position = CGPoint(x: self.frame.width/2, y: 1)
        liveNode.physicsBody = SKPhysicsBody(rectangleOf: liveNode.size)
        liveNode.physicsBody?.affectedByGravity = false
        liveNode.physicsBody?.isDynamic = true
        liveNode.physicsBody?.categoryBitMask = liveCategory
        liveNode.physicsBody?.collisionBitMask = 0
        liveNode.physicsBody?.contactTestBitMask = donkeyCategory
        liveNode.zPosition = 10
        self.addChild(liveNode)
        
    }

    
    
    func didBegin(_ contact: SKPhysicsContact){
        
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        if firstBody.categoryBitMask == donkeyCategory && secondBody.categoryBitMask == changeCategory{

            let firstN = firstBody.node as! SKShapeNode
            if firstN.name == "donkeyAlive"{

                firstN.name = "donkeyAir"
            }
            
        }else if firstBody.categoryBitMask == changeCategory && secondBody.categoryBitMask == donkeyCategory{
        
            let secondN = secondBody.node as! SKShapeNode
            if secondN.name == "donkeyAlive"{
                
                secondN.name = "donkeyAir"
            }
            
        }
        
        
        
        
        if firstBody.categoryBitMask == donkeyCategory && secondBody.categoryBitMask == liveCategory{
            
            let firstN = firstBody.node as! SKShapeNode
            if firstN.name == "donkeyAir"{
                
                
                howManyLives -= 1
                backgroundRed.color = UIColor.red
                backgroundRed.run(blinkAnimationBg())
                donkeyGenerator.removeAllChildren()
                refreshLives()
                
                
            }
            
        }else if firstBody.categoryBitMask == liveCategory && secondBody.categoryBitMask == donkeyCategory{
            
            let secondN = secondBody.node as! SKShapeNode
            if secondN.name == "donkeyAir"{
                
                
                
                howManyLives -= 1
                backgroundRed.color = UIColor.red
                backgroundRed.run(blinkAnimationBg())
                donkeyGenerator.removeAllChildren()
                refreshLives()
                

            }
            
        }
        
        
    }

    /*
    func removeLive(){
        
        backgroundRed.run(blinkAnimationBg())
        
        donkeyGenerator.enumerateChildNodes(withName: "donkeyAir", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))
        
        
        donkeyGenerator.enumerateChildNodes(withName: "camel", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))
        
        donkeyGenerator.enumerateChildNodes(withName: "donkeyAlive", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))
        
        donkeyGenerator.enumerateChildNodes(withName: "life", using: ({
            (node, error) in
            
            node.removeFromParent()
            
        }))
        
        howManyLives -= 1
        

        
        if livesLeft.children.first != nil{
            let firstheart = livesLeft.children.first
            firstheart?.removeFromParent()
        }

        
    }*/
    
    var Highscore = Int()
    func noMoreLives(){
        
        donkeyGenerator.stopGenerating()
        
        let ScoreDefault = UserDefaults.standard
        ScoreDefault.set(Score, forKey: "Score")
        //ScoreDefault.synchronize()
        
        if (Score > Highscore){
            let HighscoreDefault = UserDefaults.standard
            HighscoreDefault.set(Score, forKey: "Highscore")
        }
        
        
        let transition = SKTransition.fade(withDuration: 1.5)
        let gameOverScene = GameOverScene(size: self.size)
        
        self.view?.presentScene(gameOverScene, transition: transition)
        
        
    }

    
    func addTapToStartLabel(){
        
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = self.size.width/2   //view!.center.x
        tapToStartLabel.position.y = self.size.height/2 + 60  //view!.center.y + staticViewSize*2.0
        tapToStartLabel.fontName = "Cartoon Relief"
        tapToStartLabel.fontColor = UIColor.orange
        tapToStartLabel.fontSize = 120
        addChild(tapToStartLabel)
        tapToStartLabel.run(blinkAnimation())
        
        
    }
    
    func blinkAnimation() -> SKAction{
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
        
    }
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    func createSounds(){
        
        
        let bgMusicURL = Bundle.main.url(forResource: "Funny Frog Loop", withExtension: "wav")
        do{
            try backgroundMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL!)
        }catch{
            //print("can't play")
        }
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        //backgroundMusicPlayer.play()
        
    }
    
    var soundBtn: SKSpriteNode!
    
    func createSoundBtn(){
        
        
        let soundDefault = UserDefaults.standard
        if(soundDefault.value(forKey: "Sound") != nil){
            sounds = soundDefault.value(forKey: "Sound") as! NSInteger
        }else{
            sounds = 0
        }
        
        
        
        if sounds == 0 {
            soundBtn = SKSpriteNode(imageNamed: "orangeon.png")
            soundBtn.name = "soundOn"
        }else{
            soundBtn = SKSpriteNode(imageNamed: "orangeoff.png")
            soundBtn.name = "soundOff"
        }
        
        
        soundBtn.size = CGSize(width: 200, height: 200)
        soundBtn.position = CGPoint(x: soundBtn.size.width/2, y: soundBtn.size.height/2)
        soundBtn.zPosition = 6
        self.addChild(soundBtn)
        
    }
    

    var nextUp:Int = 5
    
    var donkeySpawn:TimeInterval = 0.8
    
    override func update(_ currentTime: TimeInterval) {
       
        
        if gameStarted == true{
        
        
            
            if Score % 5 == 0 && Score < 49 && Score >= nextUp{
                
                donkeySpawn -= 0.03
                donkeyGenerator.stopGenerating()
                donkeyGenerator.startGeneratingWithSpawnTime(seconds: donkeySpawn)
                nextUp += 5
                
            }else if Score % 10 == 0 && Score > 49 && Score >= nextUp && donkeySpawn > 0.3 {
               
                donkeySpawn -= 0.01
                donkeyGenerator.stopGenerating()
                donkeyGenerator.startGeneratingWithSpawnTime(seconds: donkeySpawn)
                nextUp += 10
                
            }
            
            //print("\(donkeySpawn)")
            
        
        }
        
        
    }
    
    
}
