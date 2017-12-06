//
//  GameScene.swift
//  DogShip
//
//  Created by Zhaowen Luo on 6/28/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory {
    static let Enemy : UInt32 = 1
    static let Bullet : UInt32 = 2
    static let Player : UInt32 = 3
    static let Lives: UInt32 = 4
    static let PowerUp : UInt32 = 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Highscore = Int()
    var Score: Int = 0
    
    var Player = SKSpriteNode(imageNamed: "mship.png")
    
    let liveNode = SKSpriteNode()
    var howManyLives: Int = 3
    let livesLeft = SKSpriteNode()
    
    var ScoreLbl = UILabel()
    
    var enemySpeed = Timer()
    var bulletSpeed = Timer()
    
    
    var enemySpawnSpeed:Double = 0.5
    var nextManyLives: Int = 8
    
    
    var gameStarted = Bool()
    
    var staticViewSize: CGFloat = 20.0
    
    
    override func didMove(to view: SKView) {
        
        staticViewSize = view.frame.height/16
        
        //print("\(staticViewSize)") // 30
        
        let HighscoreDefault = UserDefaults.standard
        if(HighscoreDefault.value(forKey: "Highscore") != nil){
            Highscore = HighscoreDefault.value(forKey: "Highscore") as! NSInteger
        }else{
            Highscore = 0
        }
        
        physicsWorld.contactDelegate = self
        
        //self.scene?.backgroundColor = UIColor.darkGray
        customBackground()
        
        let fireBg = SKEmitterNode(fileNamed: "FireParticle")
        
        fireBg?.particlePositionRange = CGVector(dx: view.frame.size.width*2, dy: view.frame.size.height*2)
        
        fireBg?.position = view.center //CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        
        //fireBg?.particleSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        
        self.addChild(fireBg!)
        
        
        
        //print("\(Player.size.width)") // 60
        //print("\(Player.size.height)") // 80
        //Player.setScale(0.7)
        Player.size = CGSize(width: staticViewSize*1.4, height: staticViewSize*(56/30))
        //print("\(Player.size.width)") // 42
        //print("\(Player.size.height)") // 56
        
        
        
        Player.position = CGPoint(x: self.size.width/2, y: self.size.height/5)
        Player.physicsBody = SKPhysicsBody(rectangleOf: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCatagory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Player.physicsBody?.collisionBitMask = 0
        Player.physicsBody?.isDynamic = false
        
        
        
        addLives()
        
        addTapToStartLabel()
        
        
        /*
         //speed of shoot your gun
         bulletSpeed = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.SpawnBullets), userInfo: nil, repeats: true)
         
         //speed of spawn enemies
         enemySpeed = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.SpawnEnemies), userInfo: nil, repeats: true)*/
        
        
        
        self.addChild(Player)
        
        ScoreLbl.text = "\(Score)"
        ScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: staticViewSize*(100/30), height: staticViewSize*(20/30)))
        ScoreLbl.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        ScoreLbl.textColor = UIColor.white
        ScoreLbl.font = ScoreLbl.font.withSize(staticViewSize/2)
        ScoreLbl.textAlignment = NSTextAlignment.center
        self.view?.addSubview(ScoreLbl)
        
        
        
        
        
    }
    
    func customBackground(){
        let backgroundTexture = SKTexture(imageNamed: "spacebg.jpg")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture, size: view!.frame.size)
        backgroundImage.position = view!.center
        backgroundImage.zPosition = -15
        addChild(backgroundImage)
    }
    
    
    func addTapToStartLabel(){
        
        //add start label
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        //childNode(withName: "tapToStartLabel")
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + staticViewSize*2.0
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = UIColor.green
        tapToStartLabel.fontSize = staticViewSize*(22/30)
        addChild(tapToStartLabel)
        tapToStartLabel.run(blinkAnimation())
        
        /*
         //create label
         let tapToStartLabel = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 100, height: 40))
         tapToStartLabel.name = "tapToStartLabel"
         tapToStartLabel.position.x = view!.center.x
         tapToStartLabel.position.y = view!.center.y + 60
         
         let tapToStartTexture:SKTexture
         tapToStartTexture = SKTexture(imageNamed: "startbtn.png")
         tapToStartTexture.filteringMode = SKTextureFilteringMode.nearest
         tapToStartLabel.texture = tapToStartTexture
         
         addChild(tapToStartLabel)
         tapToStartLabel.run(blinkAnimation())
         */
        
        
    }
    
    
    var immunity: Bool = false
    
    
    func didBegin(_ contact: SKPhysicsContact){
        
        
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        
        if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy) && (secondBody.categoryBitMask == PhysicsCatagory.Bullet)) || ((firstBody.categoryBitMask == PhysicsCatagory.Bullet) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy)) {
            
            CollisionWithBullet(Enemy: firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
            
        }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy) && (secondBody.categoryBitMask == PhysicsCatagory.Player)) || ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy)) && immunity == false {
            
            //CollisionWithPerson(Enemy: firstBody.node as! SKSpriteNode, Person: secondBody.node as! SKSpriteNode)
            
            immunity = true
            
            Player.run(blinkImmune())
            
            howManyLives -= 1
            
            //nextManyLives -= 1
            
            if howManyLives <= 0 {
                //noMoreLives()
                
                CollisionWithPerson(Enemy: firstBody.node as! SKSpriteNode, Person: secondBody.node as! SKSpriteNode)
                
            }
            
            
            enumerateChildNodes(withName: "Enemy", using: ({
                (node, error) in
                
                node.removeFromParent()
                
            }))
            
            
            
            if genesisMode == true{
                
                
                if genThreeUnlock == true{
                    
                    genesisSpeed = 2.0
                    nextLevelGenesis()
                    
                    
                    EnemySpawnSpeedTwo = 0.5
                    
                    enemySpeedTwo.invalidate()
                    
                    enemySpeedTwo = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedTwo, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    
                    
                    EnemySpawnSpeedThree = 1.0
                    
                    enemySpeedThree.invalidate()
                    
                    enemySpeedThree = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedThree, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    
                }else if genTwoUnlock == true{
                    
                    genesisSpeed = 2.0
                    nextLevelGenesis()
                    
                    EnemySpawnSpeedTwo = 1.0
                    
                    enemySpeedTwo.invalidate()
                    
                    enemySpeedTwo = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedTwo, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    
                }else{
                    
                    genesisSpeed = 2.0
                    nextLevelGenesis()
                    
                }
                
            }
            
            // too hard
            resetBullets()
            
            removeLive()
            
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.immunity = false
            }
            
            
        }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy) && (secondBody.categoryBitMask == PhysicsCatagory.Lives)) || ((firstBody.categoryBitMask == PhysicsCatagory.Lives) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy)) && immunity == false {
            
            immunity = true
            
            Player.run(blinkImmune())
            
            

            
            
            howManyLives -= 1
            
            //nextManyLives -= 1
            
            if howManyLives <= 0 {
                noMoreLives()
            }
            
            
            enumerateChildNodes(withName: "Enemy", using: ({
                (node, error) in
                
                node.removeFromParent()
                
            }))
            
            
            if genesisMode == true{
                
                
                if genThreeUnlock == true{
                    
                    genesisSpeed = 2.0
                    nextLevelGenesis()
                    
                    
                    EnemySpawnSpeedTwo = 0.5
                    
                    enemySpeedTwo.invalidate()
                    
                    enemySpeedTwo = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedTwo, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    
                    
                    EnemySpawnSpeedThree = 1.0
                    
                    enemySpeedThree.invalidate()
                    
                    enemySpeedThree = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedThree, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    
                }else if genTwoUnlock == true{
                    
                    genesisSpeed = 2.0
                    nextLevelGenesis()
                    
                    EnemySpawnSpeedTwo = 1.0
                    
                    enemySpeedTwo.invalidate()
                    
                    enemySpeedTwo = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedTwo, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    
                }else{
                    
                    genesisSpeed = 2.0
                    nextLevelGenesis()
                    
                }
                
            }
            
            
            resetBullets()
            
            removeLive()
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.immunity = false
            }
            
        }
        
        
        
        if ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.PowerUp)){
            
            CollisionWithPowerUp(PowerUp: secondBody.node as! SKSpriteNode)
            
        } else if ((firstBody.categoryBitMask == PhysicsCatagory.PowerUp) && (secondBody.categoryBitMask == PhysicsCatagory.Player)){
            
            CollisionWithPowerUp(PowerUp: firstBody.node as! SKSpriteNode)
            
        }
        
        
        
        
        
    }
    
    
    
    func addLives(){
        
        //add score line
        
        liveNode.size = CGSize(width: self.frame.width, height: 1)
        liveNode.position = CGPoint(x: self.frame.width/2, y: 0)
        //liveNode.color = UIColor.red
        //liveNode.zPosition = 10
        liveNode.physicsBody = SKPhysicsBody(rectangleOf: liveNode.size)
        liveNode.physicsBody?.affectedByGravity = false
        liveNode.physicsBody?.isDynamic = false
        liveNode.physicsBody?.categoryBitMask = PhysicsCatagory.Lives
        liveNode.physicsBody?.collisionBitMask = 0
        liveNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        self.addChild(liveNode)
        
        
        livesLeft.size = CGSize(width: (staticViewSize*(20/30))*CGFloat(howManyLives), height: staticViewSize*(20/30))
        livesLeft.position = CGPoint(x: self.frame.width-CGFloat(howManyLives)*staticViewSize*(20/30) ,y: self.frame.height-staticViewSize*(20/30))
        livesLeft.alpha = 0.5
        
        for i in 0..<howManyLives {
            
            let heart = SKSpriteNode(imageNamed: "heartlives.png")
            heart.size = CGSize(width: staticViewSize*(20/30), height: staticViewSize*(20/30))
            heart.anchorPoint = CGPoint.zero
            heart.position = CGPoint(x: CGFloat(i)*heart.frame.width, y: 0)
            livesLeft.addChild(heart)
            
        }
        
        self.addChild(livesLeft)
        
    }
    
    
    func removeLive(){
        
        let firstheart = livesLeft.children.first
        
        firstheart?.removeFromParent()
        
    }
    
    
    func CollisionWithBullet(Enemy: SKSpriteNode, Bullet: SKSpriteNode){
        
        Enemy.removeFromParent()
        Bullet.removeFromParent()
        
        Score += 1
        
        ScoreLbl.text = "\(Score)"
        
    }
    
    func CollisionWithPerson(Enemy: SKSpriteNode, Person: SKSpriteNode){
        
        
        let ScoreDefault = UserDefaults.standard
        ScoreDefault.set(Score, forKey: "Score")
        ScoreDefault.synchronize()
        
        if (Score > Highscore){
            let HighscoreDefault = UserDefaults.standard
            HighscoreDefault.set(Score, forKey: "Highscore")
        }
        
        
        Enemy.removeFromParent()
        
        //GodMode /**/
        
        Person.removeFromParent()
        self.view?.presentScene(EndScene())
        ScoreLbl.removeFromSuperview()
        
        
        
        
    }
    
    var myPower: Int = 1
    
    var resetBulletTimer = Timer()
    
    func CollisionWithPowerUp(PowerUp: SKSpriteNode){
        
        
        if myPower == 1{
        
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsTwo), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 2{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsTwo), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 3{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsThree), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 4{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsThree), userInfo: nil, repeats: true)
            myPower += 1
            
        }else if myPower == 5{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsFour), userInfo: nil, repeats: true)
            myPower += 1
            
        }else if myPower == 6{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsFour), userInfo: nil, repeats: true)
            myPower += 1
            
        }else if myPower == 7{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsFive), userInfo: nil, repeats: true)
            myPower += 1
            
        }else if myPower == 8{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsFive), userInfo: nil, repeats: true)
            
        }
        
        
        /*
        resetBulletTimer.invalidate()
        resetBulletTimer = Timer.scheduledTimer(timeInterval: 9, target: self, selector: #selector(self.resetBullets), userInfo: nil, repeats: true) */
        
        
        PowerUp.removeFromParent()
        
        
    }
    
    
    
    func resetBullets(){
    
        
        
        if myPower > 1{
        
            myPower -= 2
            
            ResetBulletsPower()
        
        }
        
    }
    
    
    func ResetBulletsPower(){
        
        
        if myPower == 0{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBullets), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 1{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsTwo), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 2{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsTwo), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 3{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsThree), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 4{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsThree), userInfo: nil, repeats: true)
            
            myPower += 1
            
        }else if myPower == 5{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsFour), userInfo: nil, repeats: true)
            myPower += 1
            
        }else if myPower == 6{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsFour), userInfo: nil, repeats: true)
            myPower += 1
            
        }else if myPower == 7{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBulletsFive), userInfo: nil, repeats: true)
            myPower += 1
            
        }else if myPower == 8{
            
            bulletSpeed.invalidate()
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.SpawnBulletsFive), userInfo: nil, repeats: true)
            
        }
        
        
    }
    
    
    func noMoreLives(){
        
        let ScoreDefault = UserDefaults.standard
        ScoreDefault.set(Score, forKey: "Score")
        ScoreDefault.synchronize()
        
        if (Score > Highscore){
            let HighscoreDefault = UserDefaults.standard
            HighscoreDefault.set(Score, forKey: "Highscore")
        }
        
        /* God Mode */
        self.view?.presentScene(EndScene())
        ScoreLbl.removeFromSuperview()
        
    }
    
    
    func SpawnBullets(){
        
        let Bullet = SKSpriteNode(imageNamed: "dogbullet.png")
        Bullet.zPosition = -5
        
        Bullet.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        
        
        Bullet.position = CGPoint(x: Player.position.x, y: Player.position.y)
        
        let action = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        
        //Bullet.run(SKAction.repeatForever(action))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Bullet.physicsBody?.collisionBitMask = 0
        Bullet.physicsBody?.isDynamic = false
        
        
        self.addChild(Bullet)
        
        
        
    }
    
    
    func SpawnBulletsTwo(){
        
        let Bullet = SKSpriteNode(imageNamed: "dogbullet.png")
        Bullet.zPosition = -5
        Bullet.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        Bullet.position = CGPoint(x: Player.position.x-staticViewSize*(10/30), y: Player.position.y)
        
        let action = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        
        //Bullet.run(SKAction.repeatForever(action))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Bullet.physicsBody?.collisionBitMask = 0
        Bullet.physicsBody?.isDynamic = false
        
        self.addChild(Bullet)
        
        let BulletTwo = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletTwo.zPosition = -5
        BulletTwo.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletTwo.position = CGPoint(x: Player.position.x+staticViewSize*(10/30), y: Player.position.y)
        
        let actionTwo = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneTwo = SKAction.removeFromParent()
        BulletTwo.run(SKAction.sequence([actionTwo, actionDoneTwo]))
        
        //Bullet.run(SKAction.repeatForever(action))
        
        BulletTwo.physicsBody = SKPhysicsBody(rectangleOf: BulletTwo.size)
        BulletTwo.physicsBody?.affectedByGravity = false
        BulletTwo.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletTwo.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletTwo.physicsBody?.collisionBitMask = 0
        BulletTwo.physicsBody?.isDynamic = false
        
        
        self.addChild(BulletTwo)
        
    }
    
    func SpawnBulletsThree(){
        
        let Bullet = SKSpriteNode(imageNamed: "dogbullet.png")
        Bullet.zPosition = -5
        Bullet.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        Bullet.position = CGPoint(x: Player.position.x-staticViewSize*(15/30), y: Player.position.y)
        let action = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Bullet.physicsBody?.collisionBitMask = 0
        Bullet.physicsBody?.isDynamic = false
        self.addChild(Bullet)
        
        
        let BulletTwo = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletTwo.zPosition = -5
        BulletTwo.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletTwo.position = CGPoint(x: Player.position.x+staticViewSize*(15/30), y: Player.position.y)
        let actionTwo = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneTwo = SKAction.removeFromParent()
        BulletTwo.run(SKAction.sequence([actionTwo, actionDoneTwo]))
        BulletTwo.physicsBody = SKPhysicsBody(rectangleOf: BulletTwo.size)
        BulletTwo.physicsBody?.affectedByGravity = false
        BulletTwo.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletTwo.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletTwo.physicsBody?.collisionBitMask = 0
        BulletTwo.physicsBody?.isDynamic = false
        self.addChild(BulletTwo)
        
        
        let BulletThree = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletThree.zPosition = -5
        BulletThree.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletThree.position = CGPoint(x: Player.position.x, y: Player.position.y)
        let actionThree = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneThree = SKAction.removeFromParent()
        BulletThree.run(SKAction.sequence([actionThree, actionDoneThree]))
        BulletThree.physicsBody = SKPhysicsBody(rectangleOf: BulletThree.size)
        BulletThree.physicsBody?.affectedByGravity = false
        BulletThree.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletThree.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletThree.physicsBody?.collisionBitMask = 0
        BulletThree.physicsBody?.isDynamic = false
        self.addChild(BulletThree)
        
        
    }
    
    func SpawnBulletsFour(){
        
        let Bullet = SKSpriteNode(imageNamed: "dogbullet.png")
        Bullet.zPosition = -5
        Bullet.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        Bullet.position = CGPoint(x: Player.position.x+staticViewSize*(20/30), y: Player.position.y)
        let action = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Bullet.physicsBody?.collisionBitMask = 0
        Bullet.physicsBody?.isDynamic = false
        self.addChild(Bullet)
        
        
        let BulletTwo = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletTwo.zPosition = -5
        BulletTwo.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletTwo.position = CGPoint(x: Player.position.x+staticViewSize*(10/30), y: Player.position.y)
        let actionTwo = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneTwo = SKAction.removeFromParent()
        BulletTwo.run(SKAction.sequence([actionTwo, actionDoneTwo]))
        BulletTwo.physicsBody = SKPhysicsBody(rectangleOf: BulletTwo.size)
        BulletTwo.physicsBody?.affectedByGravity = false
        BulletTwo.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletTwo.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletTwo.physicsBody?.collisionBitMask = 0
        BulletTwo.physicsBody?.isDynamic = false
        self.addChild(BulletTwo)
        
        
        let BulletThree = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletThree.zPosition = -5
        BulletThree.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletThree.position = CGPoint(x: Player.position.x-staticViewSize*(10/30), y: Player.position.y)
        let actionThree = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneThree = SKAction.removeFromParent()
        BulletThree.run(SKAction.sequence([actionThree, actionDoneThree]))
        BulletThree.physicsBody = SKPhysicsBody(rectangleOf: BulletThree.size)
        BulletThree.physicsBody?.affectedByGravity = false
        BulletThree.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletThree.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletThree.physicsBody?.collisionBitMask = 0
        BulletThree.physicsBody?.isDynamic = false
        self.addChild(BulletThree)
        
        
        let BulletFour = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletFour.zPosition = -5
        BulletFour.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletFour.position = CGPoint(x: Player.position.x-staticViewSize*(20/30), y: Player.position.y)
        let actionFour = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneFour = SKAction.removeFromParent()
        BulletFour.run(SKAction.sequence([actionFour, actionDoneFour]))
        BulletFour.physicsBody = SKPhysicsBody(rectangleOf: BulletFour.size)
        BulletFour.physicsBody?.affectedByGravity = false
        BulletFour.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletFour.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletFour.physicsBody?.collisionBitMask = 0
        BulletFour.physicsBody?.isDynamic = false
        self.addChild(BulletFour)
        
        
    }
    
    func SpawnBulletsFive(){
        
        let Bullet = SKSpriteNode(imageNamed: "dogbullet.png")
        Bullet.zPosition = -5
        Bullet.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        Bullet.position = CGPoint(x: Player.position.x+staticViewSize*(25/30), y: Player.position.y)
        let action = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Bullet.physicsBody?.collisionBitMask = 0
        Bullet.physicsBody?.isDynamic = false
        self.addChild(Bullet)
        
        
        let BulletTwo = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletTwo.zPosition = -5
        BulletTwo.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletTwo.position = CGPoint(x: Player.position.x+staticViewSize*(15/30), y: Player.position.y)
        let actionTwo = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneTwo = SKAction.removeFromParent()
        BulletTwo.run(SKAction.sequence([actionTwo, actionDoneTwo]))
        BulletTwo.physicsBody = SKPhysicsBody(rectangleOf: BulletTwo.size)
        BulletTwo.physicsBody?.affectedByGravity = false
        BulletTwo.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletTwo.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletTwo.physicsBody?.collisionBitMask = 0
        BulletTwo.physicsBody?.isDynamic = false
        self.addChild(BulletTwo)
        
        
        let BulletThree = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletThree.zPosition = -5
        BulletThree.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletThree.position = CGPoint(x: Player.position.x, y: Player.position.y)
        let actionThree = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneThree = SKAction.removeFromParent()
        BulletThree.run(SKAction.sequence([actionThree, actionDoneThree]))
        BulletThree.physicsBody = SKPhysicsBody(rectangleOf: BulletThree.size)
        BulletThree.physicsBody?.affectedByGravity = false
        BulletThree.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletThree.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletThree.physicsBody?.collisionBitMask = 0
        BulletThree.physicsBody?.isDynamic = false
        self.addChild(BulletThree)
        
        
        let BulletFour = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletFour.zPosition = -5
        BulletFour.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletFour.position = CGPoint(x: Player.position.x-staticViewSize*(15/30), y: Player.position.y)
        let actionFour = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneFour = SKAction.removeFromParent()
        BulletFour.run(SKAction.sequence([actionFour, actionDoneFour]))
        BulletFour.physicsBody = SKPhysicsBody(rectangleOf: BulletFour.size)
        BulletFour.physicsBody?.affectedByGravity = false
        BulletFour.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletFour.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletFour.physicsBody?.collisionBitMask = 0
        BulletFour.physicsBody?.isDynamic = false
        self.addChild(BulletFour)
        
        
        let BulletFive = SKSpriteNode(imageNamed: "dogbullet.png")
        BulletFive.zPosition = -5
        BulletFive.size = CGSize(width: staticViewSize*(6/30), height: staticViewSize*(12/30))
        BulletFive.position = CGPoint(x: Player.position.x-staticViewSize*(25/30), y: Player.position.y)
        let actionFive = SKAction.moveTo(y: self.size.height + staticViewSize*(30/30), duration: 1.0)
        let actionDoneFive = SKAction.removeFromParent()
        BulletFive.run(SKAction.sequence([actionFive, actionDoneFive]))
        BulletFive.physicsBody = SKPhysicsBody(rectangleOf: BulletFive.size)
        BulletFive.physicsBody?.affectedByGravity = false
        BulletFive.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        BulletFive.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        BulletFive.physicsBody?.collisionBitMask = 0
        BulletFive.physicsBody?.isDynamic = false
        self.addChild(BulletFive)
        
    }
    
    
    
    
    
    func SpawnEnemies(){
        
        let Enemy = SKSpriteNode(imageNamed: "menemyship.png")
        
        Enemy.name = "Enemy"
        
        //Enemy.setScale(0.6)
        
        //Player.setScale(0.7)
        Enemy.size = CGSize(width: staticViewSize*1.2, height: staticViewSize*1.6)
        //print("\(Enemy.size.width)") // 42
        //print("\(Enemy.size.height)") // 56
        
        
        let MinValue = CGFloat(staticViewSize*(40/30))
        let MaxValue = self.size.width - staticViewSize*(40/30)
        let SpawnPoint = UInt32(MaxValue - MinValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint))+MinValue, y: self.size.height)
        
        Enemy.physicsBody = SKPhysicsBody(rectangleOf: Enemy.size)
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.categoryBitMask = PhysicsCatagory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.Bullet | PhysicsCatagory.Lives | PhysicsCatagory.Player
        Enemy.physicsBody?.collisionBitMask = 0 // PhysicsCatagory.Player
        Enemy.physicsBody?.isDynamic = true
        
        let action = SKAction.moveTo(y: -staticViewSize*(70/30), duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        
        
        let randmoves = CGFloat(arc4random_uniform(UInt32(Int(staticViewSize*(40/30))))) + staticViewSize*(10/30)
        let up = SKAction.moveBy(x: randmoves, y: 0, duration: 0.25)
        let wait = SKAction.moveBy(x: 0, y: 0, duration: 0.25)
        let down = SKAction.moveBy(x: -randmoves, y: 0, duration: 0.25)
        let rand = arc4random_uniform(2)
        if rand == 0 {
            Enemy.run(SKAction.sequence([up, down, wait, down, up, wait, up, down]))
        }else{
            Enemy.run(SKAction.sequence([down, up, wait, up, down, wait, down, up]))
        }
        
        
        Enemy.run(SKAction.sequence([action, actionDone]))
        
        //Enemy.run(SKAction.repeatForever(action))
        
        self.addChild(Enemy)
        
        
    }
    
    
    func PowerUp(){
        
        let powerUp = SKSpriteNode(imageNamed: "powerup.png")
        
        //powerUp.setScale(0.05)
        //print("\(powerUp.size.width)")
        //print("\(powerUp.size.height)")
        powerUp.size = CGSize(width: staticViewSize*(15/30), height: staticViewSize*(15/30))
        
        powerUp.zPosition = -10
        
        let MinValue = staticViewSize*(30/30)
        let MaxValue = self.size.width - staticViewSize*(30/30)
        let SpawnPoint = UInt32(MaxValue - MinValue)
        powerUp.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint))+MinValue, y: self.size.height)
        
        powerUp.physicsBody = SKPhysicsBody(rectangleOf: powerUp.size)
        powerUp.physicsBody?.affectedByGravity = false
        powerUp.physicsBody?.categoryBitMask = PhysicsCatagory.PowerUp
        powerUp.physicsBody?.contactTestBitMask = PhysicsCatagory.Player
        powerUp.physicsBody?.collisionBitMask = 0 // PhysicsCatagory.Player
        powerUp.physicsBody?.isDynamic = true
        
        let action = SKAction.moveTo(y: -staticViewSize*(70/30), duration: 3.0)
        let actionDone = SKAction.removeFromParent()
        
        let randmoves = CGFloat(arc4random_uniform(UInt32(Int(staticViewSize*(60/30))))) + staticViewSize*(20/30)
        let up = SKAction.moveBy(x: randmoves, y: 0, duration: 0.5)
        let wait = SKAction.moveBy(x: 0, y: 0, duration: 0.5)
        let down = SKAction.moveBy(x: -randmoves, y: 0, duration: 0.5)
        let rand = arc4random_uniform(2)
        if rand == 0 {
            powerUp.run(SKAction.sequence([up, wait, down, down,  wait, up]))
        }else{
            powerUp.run(SKAction.sequence([down, wait, up, up, wait, down]))
        }
        
        
        powerUp.run(SKAction.sequence([action, actionDone]))
        
        //Enemy.run(SKAction.repeatForever(action))
        
        self.addChild(powerUp)
        
    }
    
    
    
    func SpawnEnemiesG(num: Double){
        
        let Enemy = SKSpriteNode(imageNamed: "menemyship.png")
        
        Enemy.name = "Enemy"
        
        Enemy.size = CGSize(width: staticViewSize*1.2, height: staticViewSize*1.6)
        
        let MinValue = staticViewSize*(40/30)
        let MaxValue = self.size.width - staticViewSize*(40/30)
        let SpawnPoint = UInt32(MaxValue - MinValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint))+MinValue, y: self.size.height)
        
        Enemy.physicsBody = SKPhysicsBody(rectangleOf: Enemy.size)
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.categoryBitMask = PhysicsCatagory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.Bullet | PhysicsCatagory.Lives | PhysicsCatagory.Player
        Enemy.physicsBody?.collisionBitMask = 0 // PhysicsCatagory.Player
        Enemy.physicsBody?.isDynamic = true
        
        let action = SKAction.moveTo(y: -staticViewSize*(70/30), duration: num)
        let actionDone = SKAction.removeFromParent()
        
        
        let randmoves = CGFloat(arc4random_uniform(UInt32(Int(staticViewSize*(70/30))))) + staticViewSize*(10/30)
        let up = SKAction.moveBy(x: randmoves, y: 0, duration: 0.25)
        let wait = SKAction.moveBy(x: 0, y: 0, duration: 0.25)
        let down = SKAction.moveBy(x: -randmoves, y: 0, duration: 0.25)
        let rand = arc4random_uniform(2)
        if rand == 0 {
            Enemy.run(SKAction.sequence([up, down, wait, down, up, wait, up, down]))
        }else{
            Enemy.run(SKAction.sequence([down, up, wait, up, down, wait, down, up]))
        }
        
        
        Enemy.run(SKAction.sequence([action, actionDone]))
        
        self.addChild(Enemy)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if gameStarted == false{
            
            gameStarted = true
            
            let tapToStartLabel = childNode(withName: "tapToStartLabel")
            tapToStartLabel?.removeFromParent()
            
            //speed of shoot your gun
            bulletSpeed = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(self.SpawnBullets), userInfo: nil, repeats: true)
            
            //speed of spawn enemies
            enemySpeed = Timer.scheduledTimer(timeInterval: enemySpawnSpeed, target: self, selector: #selector(self.SpawnEnemies), userInfo: nil, repeats: true)
            
            
            _ = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.PowerUp), userInfo: nil, repeats: true)
            
            
            
            
        }
        
 
        
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if gameStarted == true{
            
            for touch in touches {
                let location = touch.location(in: self)
                
                Player.position.x = location.x
                Player.position.y = location.y
                
                
            }
            
            
        }
        
        
        
    }
    
    
    func nextLevel(){
    
        
        if nextManyLives < howManyLives{
        
            enemySpawnSpeed -= 0.05
            
            enemySpeed.invalidate()
            
            
            enemySpeed = Timer.scheduledTimer(timeInterval: enemySpawnSpeed, target: self, selector: #selector(self.SpawnEnemies), userInfo: nil, repeats: true)
            
            //nextManyLives = howManyLives - 1
            
            
        }else {
        
            nextManyLives = howManyLives - 1
        }

        
    }
    
    func SEG(){
        
        self.SpawnEnemiesG(num: genesisSpeed)
        
    }
    
    var genesisSpeed: Double = 2.0
    
    var EnemySpawnSpeedTwo: Double = 0.9
    
    var enemySpeedTwo = Timer()
    
    var EnemySpawnSpeedThree: Double = 0.9
    
    var enemySpeedThree = Timer()

    var genTwoUnlock = Bool()
    var genThreeUnlock = Bool()
    
    func nextLevelGenesis(){
        
        
        if nextManyLives < howManyLives{
            
            if genesisSpeed <= 1.9 && genesisSpeed > 1.8{
                
                if EnemySpawnSpeedTwo > 0.4{
                
                    enemySpeedTwo.invalidate()
                    enemySpeedTwo = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedTwo, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    EnemySpawnSpeedTwo -= 0.5
                    
                }
                
                

                
                genTwoUnlock = true
                
                //print(" E2 \(EnemySpawnSpeedTwo)")
                
                genesisSpeed -= 0.02
                
                
            }else if genesisSpeed <= 1.8{
                
                if EnemySpawnSpeedTwo > 0.15{
                    
                    enemySpeedTwo.invalidate()
                    enemySpeedTwo = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedTwo, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    EnemySpawnSpeedTwo -= 0.02
                    
                }
                
                
                if EnemySpawnSpeedThree > 0.15{
                    
                    enemySpeedThree.invalidate()
                    enemySpeedThree = Timer.scheduledTimer(timeInterval: EnemySpawnSpeedThree, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
                    EnemySpawnSpeedThree -= 0.05
                    
                }
            
                //print("\(EnemySpawnSpeedThree)")
                //print("GS: \(genesisSpeed)")
                
                genThreeUnlock = true
                
                genesisSpeed -= 0.01
                
                
            }else{
            
                enemySpeed.invalidate()
                
                genesisSpeed -= 0.02
                
                enemySpeed = Timer.scheduledTimer(timeInterval: enemySpawnSpeed, target: self, selector: #selector(self.SEG), userInfo: nil, repeats: true)
            
            }
            

            
            
        }else {
            
            nextManyLives = howManyLives - 1
        }
        
    }
    
    
    

    var scoreNext: Int = 4
    var scoreGen: Int = 14
    var genesisMode = Bool()
    
    override func update(_ currentTime: TimeInterval) {
        
        
        if gameStarted == true {
            
            
            if Score % 5 == 0 && Score > scoreNext && enemySpawnSpeed <= 0.5 && enemySpawnSpeed >= 0.15 {

                scoreNext += 5
                scoreGen += 5

                
                nextLevel()
                
            }else if Score % 20 == 0 && Score > scoreGen && genesisSpeed > 1.0{
                
                genesisMode = true
                
                scoreGen += 20
                
                nextLevelGenesis()
                
            }
            
            
        }
        
    }
    
    // MARK: - Animations
    func blinkAnimation() -> SKAction{
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
        
    }
    
    // MARK: - Animations
    func blinkImmune() -> SKAction{
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.sequence([blink, blink, blink, blink, blink])
    }
    
    
}
