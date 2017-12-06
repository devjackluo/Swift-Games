
//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLWall: SKSpriteNode{
    
    let WALL_COLOR = UIColor.yellow
    
    init(num: Int, charlie: Bool, wallSpeed: Double, wWidth: CGFloat, wHeight: CGFloat){
        
        let size = CGSize(width: wWidth*1.2, height: wHeight*1.2)
        
        let boltTexture:SKTexture
        if num == 0 {
            boltTexture = SKTexture(imageNamed: "lightning-bolt.png")
        }else if num == 1{
            boltTexture = SKTexture(imageNamed: "lightning-outline-filled.png")
        }else if num == 2{
            boltTexture = SKTexture(imageNamed: "bolt.png")
        }else{
            boltTexture = SKTexture(imageNamed: "red-lightning-bolt-hi.png")
        }
        
        boltTexture.filteringMode = SKTextureFilteringMode.nearest
        
        super.init(texture: boltTexture, color: WALL_COLOR, size: size)
        
        
        loadPhysicsBodyWithSize(size: size)
        
        if charlie == true{
            
            startMovingCharlieMode(num: wallSpeed)
            
        }
        else{
            
            startMoving()
            
        }
        
    }
    
    func loadPhysicsBodyWithSize(size: CGSize){
        
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = wallCategory
        physicsBody?.affectedByGravity = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(){
        let moveLeft = SKAction.moveBy(x: -kDefaultXToMovePerSecond, y: 0, duration: 1.0)
        run(SKAction.repeatForever(moveLeft))
    }
    
    func startMovingCharlieMode(num: Double){
        let moveLeft = SKAction.moveBy(x: -CGFloat(num), y: 0, duration: 1.0)
        run(SKAction.repeatForever(moveLeft))
    }
    
    func stopMoving(){
        removeAllActions()
    }
    
}
