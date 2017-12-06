//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLCloudGenerator: SKSpriteNode {
    
    var generationTimer: Timer!
    var cloudWidth:CGFloat = 125.0
    var cloudHeight:CGFloat = 55.0
    
    func populate(num: Int, cloudW: CGFloat, cloudH: CGFloat){
        
        cloudWidth = cloudW
        cloudHeight = cloudH
        
        for _ in 0 ..< num {
            let rand = Int(arc4random_uniform(4))
            let cloud = ZLCloud(size: CGSize(width: cloudWidth, height: cloudHeight), num: rand)
            let x = CGFloat(arc4random_uniform(UInt32(size.width))) - size.width/2
            let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height/2
            cloud.position = CGPoint(x: x, y: y)
            cloud.zPosition = -4
            addChild(cloud)
        }
        
    }
    
    func startGeneratingWithSpawnTime(seconds: TimeInterval){
        
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(ZLCloudGenerator.generateCloud), userInfo: nil, repeats: true)
        
    }
    
    func stopGenerating(){
        generationTimer.invalidate()
    }
    
    func generateCloud() {
        
        let rand = Int(arc4random_uniform(4))
        let x = size.width/2 + cloudWidth/2
        let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height/2
        let cloud = ZLCloud( size: CGSize(width: cloudWidth, height: cloudHeight), num: rand)
        cloud.position = CGPoint(x: x, y: y)
        cloud.zPosition = -4
        addChild(cloud)
        
    }
    
}
