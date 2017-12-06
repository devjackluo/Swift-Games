
//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLDonkey: SKShapeNode {
    
    init(size: CGSize, num: Int){
        
        super.init()
        
        
        let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: nil)
        self.path = path
        fillColor = UIColor.gray
        
        
        lineWidth = 0
        strokeColor = UIColor.clear
        
        
        
        var donkeyTexture:SKTexture
        if num == 13{
            donkeyTexture = SKTexture(imageNamed: "applelife.png")
            name = "life"
            zPosition = -2
            
        }else {
        
            let randDonk = arc4random_uniform(5)
            
            if randDonk == 0 {
                donkeyTexture = SKTexture(imageNamed: "donkey1.png")
                name = "donkeyAlive"
                zPosition = -1
            }else if randDonk == 1{
                donkeyTexture = SKTexture(imageNamed: "donkey2.png")
                name = "donkeyAlive"
                zPosition = -1
                
            }else if randDonk == 2{
                donkeyTexture = SKTexture(imageNamed: "donkey4.png")
                name = "donkeyAlive"
                zPosition = -1
                
            }else if randDonk == 3{
                donkeyTexture = SKTexture(imageNamed: "donkey3.png")
                name = "donkeyAlive"
                zPosition = -1
                
            }else{
                donkeyTexture = SKTexture(imageNamed: "camel.png")
                name = "camel"
                zPosition = -3
                
            }
        
        }
        
        
        let randZ = arc4random_uniform(2)
        if randZ == 0 {

            self.xScale = -1.0
        }
        
        
        donkeyTexture.filteringMode = SKTextureFilteringMode.nearest
        fillTexture = donkeyTexture
        
        
        
        loadPhysicsBodyWithSize(size: size)
        
        //fly(direction: direct)
        
        //startMoving()
        
        
        
    }
    
    func loadPhysicsBodyWithSize(size: CGSize){
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = donkeyCategory
        physicsBody?.contactTestBitMask = liveCategory | changeCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.affectedByGravity = false
        //physicsBody?.isDynamic = false
        
    }

    
    
    func fly(direction: Double){
        
        let randIm = arc4random_uniform(750)+3750
         
        let randImX = arc4random_uniform(100)+175
        
        //print("\(CGFloat(randImX)*direction)")
        
        physicsBody?.affectedByGravity = true
        physicsBody?.applyImpulse(CGVector(dx: Int(Double(randImX)*direction), dy: Int(randIm)))
        
   
        
    }
    
    
    
    func spin(){
        
    
        let randSpin = arc4random_uniform(2)
        if randSpin == 0{
            //print("-")
            let rotate = SKAction.rotate(byAngle: -CGFloat(Double.pi), duration: 3)
            run(SKAction.repeatForever(rotate))
        }else{
            //print("+")
            let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 3)
            run(SKAction.repeatForever(rotate))
        }
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    func startMoving(){
        let moveLeft = SKAction.moveBy(x: 0, y: 90, duration: 1)
        run(SKAction.repeatForever(moveLeft))
    }*/
    
    
    
}
