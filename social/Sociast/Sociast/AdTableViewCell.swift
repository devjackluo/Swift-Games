//
//  AdTableViewCell.swift
//  Sociast
//
//  Created by Zhaowen Luo on 7/25/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdTableViewCell: UITableViewCell, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        // Initialization code
        
        /*
        // Created the banner ad
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        request.testDevices = [ "437a52ae3fcded99fa9d6f6f9387e286", kGADSimulatorID ]
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-1883187213556981/3952329675"
        bannerView.rootViewController = self
        bannerView.load(request)*/
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
