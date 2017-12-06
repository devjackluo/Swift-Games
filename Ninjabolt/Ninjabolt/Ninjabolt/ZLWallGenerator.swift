
//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLWallGenerator: SKSpriteNode{
    
    var generationTimer: Timer!
    var walls = [ZLWall]()
    var wallTrackers = [ZLWall]()
    
    var charlieMode: Bool = false
    var charlieModeWallSpeed: Double = 1.0
    
    var groundHeight: CGFloat = 20.0
    
    
    func startGeneratingWallsEvery(seconds: TimeInterval, gHeight: CGFloat){
        
        groundHeight = gHeight
        
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
        
    }
    
    
    func startGeneratingWallsCharlieMode(charlie: Bool, wallSpeed: Double, gHeight: CGFloat){
        
        charlieMode = charlie
        
        charlieModeWallSpeed = wallSpeed
        
        groundHeight = gHeight
        
        if wallSpeed >= 1600 && wallSpeed < 2000 {
            
            
            generationTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
            
        }else if wallSpeed >= 2000 && wallSpeed < 2400 {
            
            
            generationTimer = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
            
        }else if wallSpeed >= 2400 && wallSpeed < 2800 {
            
            
            generationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
            
        }else if wallSpeed >= 2800 && wallSpeed < 3200 {
            
            
            generationTimer = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
            
        }else if wallSpeed >= 3200 && wallSpeed < 3600 {
            
            
            generationTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
            
        }else if wallSpeed >= 3600{
            
            
            generationTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
            
        }else {
            
            
            generationTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(ZLWallGenerator.generateWall), userInfo: nil, repeats: true)
            
        }
        
    }
    
    
    func stopGenerating(){
        generationTimer.invalidate()
    }
    
    func generateWall(){
        var scale: CGFloat
        let rand = arc4random_uniform(2)
        if rand == 0 {
            scale = -1.0
        }else{
            scale = 1.0
        }
        
        let randWall = arc4random_uniform(4)
        
        let wall = ZLWall(num: Int(randWall), charlie: charlieMode, wallSpeed: charlieModeWallSpeed, wWidth: groundHeight/3, wHeight: groundHeight*2)
        wall.position.x = size.width/2 + wall.size.width/2
        wall.position.y = scale * (groundHeight/2 + wall.size.height/2)
        walls.append(wall)
        wallTrackers.append(wall)
        
        if rand == 1 {
            wall.yScale = -1.0
        }
        
        /*
         let randX = arc4random_uniform(2)
         if randX == 0 {
         wall.xScale = -1.0
         }*/
        
        addChild(wall)
        
    }
    
    func stopWalls(){
        stopGenerating()
        for wall in walls{
            wall.stopMoving()
        }
    }
    
}
