//
//  GameScene.swift
//  FlappyNinja
//
//  Created by Zhaowen Luo on 6/27/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory{
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var Ground = SKSpriteNode()
    var Ghost = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    
    let scoreLbl = SKLabelNode()
    
    var died = Bool()
    
    var restartBTN = SKSpriteNode()
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    
    }
    
    func createScene(){
        
    
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2{
            let background = SKSpriteNode(imageNamed: "cartoonbg.jpg")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i)*self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        
        //add score label
        scoreLbl.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "04b_19"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 40
        self.addChild(scoreLbl)
        
        //add ground
        Ground = SKSpriteNode(imageNamed: "ronground.png")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width/2 , y: 0 + Ground.frame.height/2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        
        //add ghost
        Ghost = SKSpriteNode(imageNamed: "nenebird.png")
        Ghost.size = CGSize(width: 60, height: 70)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height/2)
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height/2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.isDynamic = true
        
        Ghost.zPosition = 2
        
        self.addChild(Ghost)
        
    }
    
    
    override func didMove(to view: SKView) {
        
        

        createScene()
        
    }
    
    func createBTN(){
        
        restartBTN = SKSpriteNode(imageNamed: "restart.png")
        restartBTN.size = CGSize(width: 214, height: 75)
        restartBTN.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        
        restartBTN.run(SKAction.scale(to: 1.0, duration: 0.3))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
        
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        
        } else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Score{
        
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            
            
        } else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
        
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            
            if died == false{
                died = true
                createBTN()
            }
            
            
            
        }else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Ground || firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
            
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            
            if died == false{
                died = true
                createBTN()
            }
            
            
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false{
            
            gameStarted = true
            
            Ghost.physicsBody?.affectedByGravity = true
        
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
                
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 150, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            //control the jump of ghost
            Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
            
        }else{
            
            if died == true{
            
            }else{
                
                //control the jump of ghost
                Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
            }
        }
        
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if died == true{
            
            
                if restartBTN.contains(location){
                    restartScene()
                }
                
                
            }
        
        }
        

        
    }
    

    func createWalls(){
        
        //add score line
        let scoreNode = SKSpriteNode(imageNamed: "sb.png")
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 50, y: self.frame.height/2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        //scoreNode.color = SKColor.blue
        
        
        //add walls
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "charliepipe.png")
        let btmWall = SKSpriteNode(imageNamed: "charliepipe.png")
        topWall.position = CGPoint(x: self.frame.width + 50, y: self.frame.height/2 + 350)
        btmWall.position = CGPoint(x: self.frame.width + 50, y: self.frame.height/2 - 350)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat.pi
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        
        
        let randomPosition = CGFloat.random(min: -80, max: 80)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        
        wallPair.position.y = wallPair.position.y + 25
        
        wallPair.addChild(scoreNode)
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted == true{
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x-2, y: bg.position.y)
                    
                    if bg.position.x <= -bg.size.width{
                    
                        bg.position = CGPoint(x: bg.position.x+bg.size.width*2, y: bg.position.y)
                        
                    }
                    
                }))
            }
        }
        
    }
    
    
}
