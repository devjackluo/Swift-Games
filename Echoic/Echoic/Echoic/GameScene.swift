//
//  GameScene.swift
//  Echoic
//
//  Created by Zhaowen Luo on 7/31/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, AVAudioPlayerDelegate {

    var sound1Player:AVAudioPlayer!
    var sound2Player:AVAudioPlayer!
    var sound3Player:AVAudioPlayer!
    var sound4Player:AVAudioPlayer!
    var sound5Player:AVAudioPlayer!
    var sound6Player:AVAudioPlayer!
    
    var playlist = [Int]()
    var currentItem = 0
    var numberOfTaps = 0
    var readyForUser = false
    
    var level = 1
    
    
    var playBtn = SKSpriteNode()
    
    var lvlLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    
    var c1Btn = SKSpriteNode()
    var c2Btn = SKSpriteNode()
    var c3Btn = SKSpriteNode()
    var c4Btn = SKSpriteNode()
    var c5Btn = SKSpriteNode()
    var c6Btn = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {

        setupAudioFiles()
        
        addPlayBtn()
        addColorBtn()
        addLabel()
        customBackground()
        
    }
    
    
    func setupAudioFiles(){
        
        let soundFilePath = Bundle.main.path(forResource: "1", ofType: "wav")
        let soundFileURL = URL(fileURLWithPath: soundFilePath!)
        
        let soundFilePath2 = Bundle.main.path(forResource: "1-2", ofType: "mp3")
        let soundFileURL2 = URL(fileURLWithPath: soundFilePath2!)
        
        let soundFilePath3 = Bundle.main.path(forResource: "2", ofType: "wav")
        let soundFileURL3 = URL(fileURLWithPath: soundFilePath3!)
        
        let soundFilePath4 = Bundle.main.path(forResource: "2-2", ofType: "mp3")
        let soundFileURL4 = URL(fileURLWithPath: soundFilePath4!)
        
        let soundFilePath5 = Bundle.main.path(forResource: "3", ofType: "wav")
        let soundFileURL5 = URL(fileURLWithPath: soundFilePath5!)
        
        let soundFilePath6 = Bundle.main.path(forResource: "3-2", ofType: "mp3")
        let soundFileURL6 = URL(fileURLWithPath: soundFilePath6!)
        
        do{
            
            try sound1Player = AVAudioPlayer(contentsOf: soundFileURL)
            try sound2Player = AVAudioPlayer(contentsOf: soundFileURL2)
            try sound3Player = AVAudioPlayer(contentsOf: soundFileURL3)
            try sound4Player = AVAudioPlayer(contentsOf: soundFileURL4)
            try sound5Player = AVAudioPlayer(contentsOf: soundFileURL5)
            try sound6Player = AVAudioPlayer(contentsOf: soundFileURL6)
            
        }catch {
            
            print(error)
            
        }
        
        sound1Player.delegate = self
        sound2Player.delegate = self
        sound3Player.delegate = self
        sound4Player.delegate = self
        sound5Player.delegate = self
        sound6Player.delegate = self
        
        sound1Player.numberOfLoops = 0
        sound2Player.numberOfLoops = 0
        sound3Player.numberOfLoops = 0
        sound4Player.numberOfLoops = 0
        sound5Player.numberOfLoops = 0
        sound6Player.numberOfLoops = 0
        
        
    }

    
    func customBackground(){
        let backgroundTexture = SKTexture(imageNamed: "hazy.jpeg")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture, size: self.frame.size)
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.zPosition = -50
        addChild(backgroundImage)
    }
    
    
    func addPlayBtn(){

        let playTexture = SKTexture(imageNamed: "playBtn.png")
        playBtn = SKSpriteNode(texture: playTexture)
        playBtn.position.x = self.size.width/2
        playBtn.position.y = self.size.height/2
        playBtn.name =  "playBtn"
        playBtn.zPosition = 20
        addChild(playBtn)
        
    }
    

    
    func addColorBtn(){
        
    
        let c1Texture = SKTexture(imageNamed: "c1c.png")
        c1Btn = SKSpriteNode(texture: c1Texture)
        c1Btn.setScale(0.7)
        c1Btn.position.x = self.size.width/2 - c1Btn.size.width/2 - 25 + 30 + 10 + 75
        c1Btn.position.y = self.size.height/2 + c1Btn.size.height - 20 - 60 + 20
        c1Btn.name =  "c1Btn"
        addChild(c1Btn)
        
        let c2Texture = SKTexture(imageNamed: "c2c.png")
        c2Btn = SKSpriteNode(texture: c2Texture)
        c2Btn.setScale(0.7)
        c2Btn.position.x = self.size.width/2 + c2Btn.size.width/2 + 25 + 10 + 50
        c2Btn.position.y = self.size.height/2 + c2Btn.size.height - 20 - 30 - 60
        c2Btn.name =  "c2Btn"
        addChild(c2Btn)
        
        
        let c3Texture = SKTexture(imageNamed: "c3c.png")
        c3Btn = SKSpriteNode(texture: c3Texture)
        c3Btn.setScale(0.7)
        c3Btn.position.x = self.size.width/2 + c3Btn.size.width - 20 - 30 - 20
        c3Btn.position.y = self.size.height/2 - 30 - 75
        c3Btn.name =  "c3Btn"
        addChild(c3Btn)
        
        
        
        
        
        
        
        let c4Texture = SKTexture(imageNamed: "c4c.png")
        c4Btn = SKSpriteNode(texture: c4Texture)
        c4Btn.setScale(0.7)
        c4Btn.position.x = self.size.width/2 + c4Btn.size.width/2 + 25 - 30 - 10 - 75
        c4Btn.position.y = self.size.height/2 - c4Btn.size.height + 20 + 70 - 10 - 20
        c4Btn.name =  "c4Btn"
        addChild(c4Btn)
        
        let c5Texture = SKTexture(imageNamed: "c5c.png")
        c5Btn = SKSpriteNode(texture: c5Texture)
        c5Btn.setScale(0.7)
        c5Btn.position.x = self.size.width/2 - c5Btn.size.width/2 - 40 + 10 - 50
        c5Btn.position.y = self.size.height/2 - c5Btn.size.height + 40 + 30 + 60
        c5Btn.name =  "c5Btn"
        addChild(c5Btn)
        
        
        
        let c6Texture = SKTexture(imageNamed: "c6c.png")
        c6Btn = SKSpriteNode(texture: c6Texture)
        c6Btn.setScale(0.7)
        c6Btn.position.x = self.size.width/2 - c6Btn.size.width + 20 + 30 + 20
        c6Btn.position.y = self.size.height/2 + 30 + 75
        c6Btn.name =  "c6Btn"
        addChild(c6Btn)
        
        
        //print("\(c2Btn.size.height/2)")   //179.2
        
    }
    
    
    var Highscore = Int()
    
    var soundLabel = SKLabelNode()
    
    func addLabel(){
    
        
        let HighscoreDefault = UserDefaults.standard
        if(HighscoreDefault.value(forKey: "Highscore") != nil){
            Highscore = HighscoreDefault.value(forKey: "Highscore") as! NSInteger
        }else{
            Highscore = 1
        }
        
        
        
        
        lvlLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - 300)
        lvlLabel.fontSize = 160
        lvlLabel.fontName = "Some Distant Memory"
        addChild(lvlLabel)
        
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - 120)
        scoreLabel.fontSize = 80
        scoreLabel.text = "Best: \(Highscore)"
        scoreLabel.fontName = "Some Distant Memory"
        addChild(scoreLabel)
        
        
        soundLabel.position = CGPoint(x: self.size.width/2, y: 300)
        soundLabel.fontSize = 120
        soundLabel.text = "TURN SOUND ON!"
        soundLabel.color = UIColor.red
        //soundLabel.fontName = "Some Distant Memory"
        addChild(soundLabel)
        
    
    }
    
    func pressedBtn(btnTag:Int){
    
        
        if readyForUser == true && numberOfTaps <= playlist.count - 1{
            
            //let button = sender as! UIButton
            
            switch btnTag {
                
            case 1:
                sound1Player.stop()
                sound1Player.play()
                resetButtonHighLights()
                highlightButton(tag: 1)
                checkIfCorrect(buttonPressed: 1)
                break
            case 2:
                sound2Player.stop()
                sound2Player.play()
                resetButtonHighLights()
                highlightButton(tag: 2)
                checkIfCorrect(buttonPressed: 2)
                break
            case 3:
                sound3Player.stop()
                sound3Player.play()
                resetButtonHighLights()
                highlightButton(tag: 3)
                checkIfCorrect(buttonPressed: 3)
                break
            case 4:
                sound4Player.stop()
                sound4Player.play()
                resetButtonHighLights()
                highlightButton(tag: 4)
                checkIfCorrect(buttonPressed: 4)
                break
            case 5:
                sound5Player.stop()
                sound5Player.play()
                resetButtonHighLights()
                highlightButton(tag: 5)
                checkIfCorrect(buttonPressed: 5)
                break
            case 6:
                sound6Player.stop()
                sound6Player.play()
                resetButtonHighLights()
                highlightButton(tag: 6)
                checkIfCorrect(buttonPressed: 6)
                break
            default:
                break
            }
            
        }

        
    
    }
    
    
    func checkIfCorrect(buttonPressed: Int){
        
        if buttonPressed == playlist[numberOfTaps]{
            
            if numberOfTaps == playlist.count - 1 {
                // next round
                
                lvlLabel.text = "Well Done!"
                readyForUser = false
                
                //self.disableButton()
                //numberOfTaps = 0
                //currentItem = 0
                
                //we arrived at the last item
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.nextRound()
                }
                
                //self.nextRound()
                return
            }
            
            numberOfTaps += 1
            
        }else{ //GAME OVER
            
            readyForUser = false
            resetGame()

            
        }
        
    }
    
    var gameOver = false
    
    func resetGame(){
        
        if (level > Highscore){
            
            //print("set")
            
            let HighscoreDefault = UserDefaults.standard
            HighscoreDefault.set(level, forKey: "Highscore")
            
            Highscore = level
        }
        
        scoreLabel.text = "Best: \(Highscore)"
        soundLabel.fontSize = 50
        soundLabel.text = "Sound On?"
        
        gameOver = true
        level = 1
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0
        playlist = []
        lvlLabel.text = "GAME OVER"
        resetButtonHighLights()
        
        addPlayBtn()
        
      

        
    }
    
    func nextRound(){
        
        level += 1
        lvlLabel.text = "Level \(level)"
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0

        /*playlist = []
        for _ in 1...level{
            let randomNumber = Int(arc4random_uniform(6) + 1)
            playlist.append(randomNumber)
        }*/
        
        let randomNumber = Int(arc4random_uniform(6) + 1)
        playlist.append(randomNumber)
        
        playNextItem()
        
        
        
    }


    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        for touch in touches {
            
            let location = touch.location(in: self)
            let node:SKNode = self.atPoint(location)
            
            
            if(node.name == "playBtn"){
                
          
                gameOver = false
                
                lvlLabel.text = "Level 1"
                scoreLabel.text = ""
                soundLabel.text = ""
                
                let randomNumber = Int(arc4random_uniform(6) + 1)
                
                playlist.append(randomNumber)
                playBtn.removeFromParent()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    self.playNextItem()
                }
       
            }
            
            
            if readyForUser == true && gameOver == false{
            
            
                if(node.name == "c1Btn"){
                    
                    pressedBtn(btnTag: 1)
                    
                }else if(node.name == "c2Btn"){
                    
                    pressedBtn(btnTag: 2)
                    
                }else if(node.name == "c3Btn"){
                    
                    pressedBtn(btnTag: 3)
                    
                }else if(node.name == "c4Btn"){
                    
                    pressedBtn(btnTag: 4)
                    
                }else if(node.name == "c5Btn"){
                    
                    pressedBtn(btnTag: 5)
                    
                }else if(node.name == "c6Btn"){
                    
                    pressedBtn(btnTag: 6)
                    
                }
                
            }
            
            
        }
        
        
        
    }
    
    func playNextItem(){
        let selectedItem = playlist[currentItem]
        
        switch selectedItem{
        case 1:
            highlightButton(tag: 1)
            sound1Player.play()
            break
        case 2:
            highlightButton(tag: 2)
            sound2Player.play()
            break
        case 3:
            highlightButton(tag: 3)
            sound3Player.play()
            break
        case 4:
            highlightButton(tag: 4)
            sound4Player.play()
            break
        case 5:
            highlightButton(tag: 5)
            sound5Player.play()
            break
        case 6:
            highlightButton(tag: 6)
            sound6Player.play()
            break
        default:
            break
        }
        
        currentItem += 1
        
    }
    
    func highlightButton (tag:Int){
        
        switch tag {
        case 1:
            resetButtonHighLights()
            c1Btn.texture = SKTexture(imageNamed: "c1p.png")
            //soundButton[tag-1].setImage(UIImage(named: "redPressed"), for: .normal)
            break
        case 2:
            resetButtonHighLights()
            c2Btn.texture = SKTexture(imageNamed: "c2p.png")
            break
        case 3:
            resetButtonHighLights()
            c3Btn.texture = SKTexture(imageNamed: "c3p.png")
            break
        case 4:
            resetButtonHighLights()
            c4Btn.texture = SKTexture(imageNamed: "c4p.png")
            break
        case 5:
            resetButtonHighLights()
            c5Btn.texture = SKTexture(imageNamed: "c5p.png")
            break
        case 6:
            resetButtonHighLights()
            c6Btn.texture = SKTexture(imageNamed: "c6p.png")
            break
        default:
            break
        }
        
    }
    
    func resetButtonHighLights(){
        
        c1Btn.texture = SKTexture(imageNamed: "c1c.png")
        c2Btn.texture = SKTexture(imageNamed: "c2c.png")
        c3Btn.texture = SKTexture(imageNamed: "c3c.png")
        c4Btn.texture = SKTexture(imageNamed: "c4c.png")
        c5Btn.texture = SKTexture(imageNamed: "c5c.png")
        c6Btn.texture = SKTexture(imageNamed: "c6c.png")
        
    }
    
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if readyForUser == false && gameOver == false{
            
            if currentItem <=  playlist.count - 1{
                
                resetButtonHighLights()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.playNextItem()
                }
                //playNextItem()
                
                
            }else{
                
                //print("called")
                
                readyForUser = true
                resetButtonHighLights()

            }
            
        }else{
            
            
            if sound1Player.isPlaying {
                
               
                
            }else if sound2Player.isPlaying {
                
                
                
            }else if sound3Player.isPlaying {
                
                
                
            }else if sound4Player.isPlaying {
                
               
                
            }else if sound5Player.isPlaying {
                
               
                
            }else if sound6Player.isPlaying {
                
               
                
            }else {
                
                
                resetButtonHighLights()
                
            }
            
        }
        
        
        
    }
    
    //var isPlaying = false
    
    override func update(_ currentTime: TimeInterval) {
       
        /*
        if sound1Player.isPlaying {
            
            isPlaying = true
        
        }else if sound2Player.isPlaying {
            
            isPlaying = true
            
        }else if sound3Player.isPlaying {
            
            isPlaying = true
            
        }else if sound4Player.isPlaying {
            
            isPlaying = true
            
        }else if sound5Player.isPlaying {
            
            isPlaying = true
            
        }else if sound6Player.isPlaying {
            
            isPlaying = true
            
        }else {
        
        
            isPlaying = false
            
        }*/
        
        
        //print("\(readyForUser)")
        
    }
    
    
}
