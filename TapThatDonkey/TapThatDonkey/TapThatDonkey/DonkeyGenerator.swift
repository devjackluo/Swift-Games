//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLDonkeyGenerator: SKSpriteNode {
    
    var generationTimer: Timer!
    var donkeyWidth:CGFloat = 200.0
    var donkeyHeight:CGFloat = 200.0
    
    
    func startGeneratingWithSpawnTime(seconds: TimeInterval){
        
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(ZLDonkeyGenerator.generateDonkey), userInfo: nil, repeats: true)
        
        //Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(ZLDonkeyGenerator.generateDonkeyMax), userInfo: nil, repeats: true)
        
    }
    
    
    func stopGenerating(){
        generationTimer.invalidate()
    }

    
    
    
    func generateDonkey() {
        
        var x = CGFloat(arc4random_uniform(UInt32(size.width/2-100)))
        
        var direction = Double()
        
        let randX = arc4random_uniform(2)
        if randX == 0 {
            x = -x
        }
        
        if x >= 0 {
            
            if x >= 325{
                
                //print("always")
                let ranDis = arc4random_uniform(50)+150

                direction = -Double(Double(ranDis)/100)
                
            }else if x < 300 && x >= 175{
            
                //print("always")
                let ranDis = arc4random_uniform(50)+100
                
                direction = -Double(Double(ranDis)/100)
                
            }else{
                
                direction = -1
            }
        
            
        }else if x < 0{
            
            
            if x <= -325{
                
                //print("always")
                let ranDis = arc4random_uniform(50)+150
                
                direction = Double(Double(ranDis)/100)
                
            }else if x > -300 && x <= -175{
                
                //print("always")
                let ranDis = arc4random_uniform(50)+100
                
                direction = Double(Double(ranDis)/100)
                
            }else{
                
                direction = 1
            }
            
            
        }
        
        //print("\(direction)")
        
        let y = -size.height/2
        
        let rand = Int(arc4random_uniform(100))
        
        let donkey = ZLDonkey( size: CGSize(width: donkeyWidth, height: donkeyHeight), num: rand)
        donkey.position = CGPoint(x: x, y: y-donkeyWidth)
        donkey.zPosition = 1
        addChild(donkey)
        
        donkey.fly(direction: direction)
        donkey.spin()
    }
    
    
    
    
}
