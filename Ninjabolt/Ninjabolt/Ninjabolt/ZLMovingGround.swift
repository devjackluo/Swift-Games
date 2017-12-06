//
//  Created by Zhaowen Luo on 6/22/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLMovingGround: SKSpriteNode {
    
    let NUMBER_OF_SEGMENTS = 20
    let TextureOne = SKTexture(imageNamed: "cSOne.png")
    let TextureTwo = SKTexture(imageNamed: "cSTwo.png")
    
    init(size: CGSize){
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: size.width*2, height: size.height))
        
        anchorPoint = CGPoint(x: 0, y: 0.5)
        
        for i in 0 ..< NUMBER_OF_SEGMENTS {
            var segmentTexture: SKTexture!
            if i % 2 == 0{
                
                segmentTexture = TextureOne
            }else {
                
                segmentTexture = TextureTwo
            }
            
            let segment = SKSpriteNode(texture: segmentTexture, size: CGSize(width: self.size.width/CGFloat(NUMBER_OF_SEGMENTS), height: self.size.height))
            
            segment.anchorPoint = CGPoint(x: 0, y: 0.5)
            segment.position = CGPoint(x: CGFloat(i)*segment.size.width, y: 0)
            addChild(segment)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(){
        let adjustedDuration = frame.size.width / kDefaultXToMovePerSecond
        
        
        let moveLeft = SKAction.moveBy(x: -frame.size.width/2, y: 0, duration: TimeInterval(adjustedDuration/2))
        let resetPosition = SKAction.moveTo(x: 0 , duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        
        run(SKAction.repeatForever(moveSequence))
        
    }
    
    func startCharlie(groundSpeed: Double){
        
        let adjustedDuration = frame.size.width / CGFloat(groundSpeed)
        let moveLeft = SKAction.moveBy(x: -frame.size.width/10, y: 0, duration: TimeInterval(adjustedDuration/10))
        let resetPosition = SKAction.moveTo(x: 0 , duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        run(SKAction.repeatForever(moveSequence))
        
    }
    
    func stop(){
        removeAllActions()
    }
    
}
