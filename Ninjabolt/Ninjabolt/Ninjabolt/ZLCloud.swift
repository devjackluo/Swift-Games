
//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import SpriteKit

class ZLCloud: SKShapeNode {
    init(size: CGSize, num: Int){
        
        super.init()
        
        let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: nil)
        self.path = path
        fillColor = UIColor.gray
        
        lineWidth = 0
        strokeColor = UIColor.clear
        
        let cloudTexture:SKTexture
        if num == 0 {
            cloudTexture = SKTexture(imageNamed: "clouds-png-19.png")
        }else{
            cloudTexture = SKTexture(imageNamed: "cloud_PNG.png")
        }
        cloudTexture.filteringMode = SKTextureFilteringMode.nearest
        fillTexture = cloudTexture
        
        
        startMoving()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving(){
        let moveLeft = SKAction.moveBy(x: -40, y: 0, duration: 1)
        run(SKAction.repeatForever(moveLeft))
    }
    
}
