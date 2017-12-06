//
//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLHero: SKSpriteNode {
    
    var body: SKSpriteNode!
    var arm: SKSpriteNode!
    var leftFoot: SKSpriteNode!
    var rightFoot: SKSpriteNode!
    var isUpsideDown: Bool = false
    var groundHeight: CGFloat = 20.0
    
    init(gHeight:CGFloat){
        
        groundHeight = gHeight
        
        let size = CGSize(width: groundHeight, height: groundHeight*2.2)
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        loadAppearance()
        loadPhysicsBodyWithSize(size: size)
        
        
    }
    
    func loadAppearance(){
        
        body = SKSpriteNode(color: UIColor.black, size: CGSize(width: groundHeight*1.6, height: groundHeight*2))
        body.position = CGPoint(x: 0, y: groundHeight*0.1)
        addChild(body)
        
        let skinColor = UIColor(red: 207.0/255.0, green: 193.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        let face = SKSpriteNode(color: skinColor, size: CGSize(width: groundHeight*1.6, height: groundHeight*0.6))
        face.position = CGPoint(x: 0, y: groundHeight*0.3)
        body.addChild(face)
        
        let eyeColor = UIColor.white
        let leftEye = SKSpriteNode(color: eyeColor, size: CGSize(width: groundHeight*0.3, height: groundHeight*0.3))
        let rightEye = leftEye.copy() as! SKSpriteNode
        let pupil = SKSpriteNode(color: UIColor.black, size: CGSize(width: groundHeight*0.15, height: groundHeight*0.15))
        
        pupil.position = CGPoint(x: groundHeight*0.1, y: groundHeight*0.08)
        leftEye.addChild(pupil)
        rightEye.addChild(pupil.copy() as! SKSpriteNode)
        
        leftEye.position = CGPoint(x: -groundHeight*0.2, y: 0)
        face.addChild(leftEye)
        
        rightEye.position = CGPoint(x: groundHeight*0.7, y: 0)
        face.addChild(rightEye)
        
        let eyebrow = SKSpriteNode(color: UIColor.black, size: CGSize(width: groundHeight*0.5, height: groundHeight*0.05))
        eyebrow.position = CGPoint(x: -groundHeight*0.05, y: leftEye.size.height/2)
        leftEye.addChild(eyebrow)
        rightEye.addChild(eyebrow.copy() as! SKSpriteNode)
        
        leftFoot = SKSpriteNode(color: UIColor.black, size: CGSize(width: groundHeight*0.45, height: groundHeight*0.4))
        leftFoot.position = CGPoint(x: -groundHeight*0.3, y: -size.height/2 + leftFoot.size.height/3)
        leftFoot.zPosition = -1
        addChild(leftFoot)
        
        rightFoot = leftFoot.copy() as! SKSpriteNode
        rightFoot.position.x = groundHeight*0.4
        rightFoot.zPosition = -1
        addChild(rightFoot)
        
        let armColor = UIColor(red: 46.0/255.0, green: 46.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        arm = SKSpriteNode(color: armColor, size: CGSize(width: groundHeight*0.4, height: groundHeight*0.7))
        arm.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        arm.position = CGPoint(x: -groundHeight*0.5, y: -groundHeight*0.35)
        body.addChild(arm)
        
        let hand = SKSpriteNode(color: skinColor, size: CGSize(width: arm.size.width, height: groundHeight*0.25))
        hand.position = CGPoint(x: 0, y: -arm.size.height*0.9 + hand.size.height/2)
        arm.addChild(hand)
        
        
        let hatTexture = SKTexture(imageNamed: "hat.png")
        let hat = SKSpriteNode(texture: hatTexture, size: CGSize(width: body.frame.size.width*2.5, height: body.frame.size.width*1.25))
        hat.position = CGPoint(x: 0+(arm.size.width/4), y: (body.frame.size.height/2)*0.8)
        body.addChild(hat)
        
    }
    
    func loadPhysicsBodyWithSize(size: CGSize){
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = heroCategory
        physicsBody?.contactTestBitMask = wallCategory
        physicsBody?.affectedByGravity = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip(){
        
        isUpsideDown = !isUpsideDown
        
        var scale: CGFloat!
        if isUpsideDown {
            scale = -1.0
        }else{
            scale = 1.0
        }
        let translate = SKAction.moveBy(x: 0, y: scale*(size.height + groundHeight), duration: 0.1)
        let flip = SKAction.scaleY(to: scale, duration: 0.1)
        
        run(translate)
        run(flip)
        
    }
    
    func fall(){
        physicsBody?.affectedByGravity = true
        physicsBody?.applyImpulse(CGVector(dx: -groundHeight*0.16, dy: groundHeight))
        
        let rotateBack = SKAction.rotate(byAngle: -CGFloat(Double.pi)/2, duration: 0.4)
        run(rotateBack)
        
    }
    
    
    func startRunning(){
        
        let rotateBack = SKAction.rotate(byAngle: -CGFloat(Double.pi)/2.5, duration: 0.1)
        arm.run(rotateBack)
        
        let bodyRotate = SKAction.rotate(byAngle: -CGFloat(Double.pi)/16.0, duration: 0.1)
        body.run(bodyRotate)
        
        let movelegs = SKAction.moveBy(x: -groundHeight*0.25, y: -groundHeight*0.05, duration: 0.05)
        
        
        let legS = SKAction.sequence([bodyRotate, movelegs])
        rightFoot.run(legS)
        leftFoot.run(legS)
        
        performOneRunCycle()
        performOneArmCycle()
        
    }
    
    func performOneRunCycle(){
        
        let up = SKAction.moveBy(x: 0, y: groundHeight*0.2, duration: 0.05)
        let down = SKAction.moveBy(x: 0, y: -groundHeight*0.2, duration: 0.05)
        
        leftFoot.run(up, completion: {() -> Void in
            self.leftFoot.run(down)
            self.rightFoot.run(up, completion: {() -> Void in
                self.rightFoot.run(down, completion: {() -> Void in
                    self.performOneRunCycle()
                })
            })
        })
        
    }
    
    func performOneArmCycle(){
        
        let rotateForward = SKAction.rotate(byAngle: +CGFloat(Double.pi)/1.5, duration: 0.1)
        let rotateBack = SKAction.rotate(byAngle: -CGFloat(Double.pi)/1.5, duration: 0.1)
        
        arm.run(rotateForward, completion: {() -> Void in
            self.arm.run(rotateBack, completion: {() -> Void in
                self.performOneArmCycle()
            })
        })
        
    }
    
    
    func breathe(){
        let breatheOut = SKAction.moveBy(x: 0, y: -groundHeight*0.1, duration: 1.0)
        let breatheIn = SKAction.moveBy(x: 0, y: groundHeight*0.1, duration: 1.0)
        let breath = SKAction.sequence([breatheOut, breatheIn])
        body.run(SKAction.repeatForever(breath))
    }
    
    func stop(){
        body.removeAllActions()
        leftFoot.removeAllActions()
        rightFoot.removeAllActions()
        arm.removeAllActions()
    }
    
    
}
