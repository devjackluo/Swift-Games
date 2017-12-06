//  Created by Zhaowen Luo on 6/23/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ZLPointsLabel: SKLabelNode {
    
    var number:Int = 0
    
    init(num: Int){
        super.init()
        
        fontColor = UIColor.yellow
        fontName = "Helvetica"
        fontSize = 24.0
        
        number = num
        text = "\(num)"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increment(){
        number += 1
        text = "\(number)"
    }
    
    func setTo(num: Int){
        self.number = num
        text = "\(self.number)"
    }
    
}
