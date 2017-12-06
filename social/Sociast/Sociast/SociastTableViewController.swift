//
//  SociastTableViewController.swift
//  Sociast
//
//  Created by Zhaowen Luo on 7/25/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SociastTableViewController: UITableViewController, GADBannerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "CaviarDreams", size: 20)!]
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 11
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 1)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "facebookCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 2)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "twitterCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 3)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "instagramCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 4)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "youtubeCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 5)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "imgurCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 6)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "twitchCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 7)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "tumblrCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 8)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "redditCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 9)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "pinterestCell", for: indexPath)
            
            return cell
            
        }else if (indexPath.row == 10)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdTableViewCell
            
            let cellBannerView = cell.bannerView
            
            // Created the banner ad
            let request = GADRequest()
            //request.testDevices = [kGADSimulatorID]
            request.testDevices = [ "437a52ae3fcded99fa9d6f6f9387e286", "63457f81415bc4a71391f2c96fba3d2b", kGADSimulatorID ]
            cellBannerView?.delegate = self
            cellBannerView?.adUnitID = "ca-app-pub-1883187213556981/3952329675"
            cellBannerView?.rootViewController = self
            cellBannerView?.load(request)
            
            return cell
            
            
        }else if (indexPath.row == 0)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdTableViewCell
            
            let cellBannerView = cell.bannerView
            
            // Created the banner ad
            let request = GADRequest()
            //request.testDevices = [kGADSimulatorID]
            request.testDevices = [ "437a52ae3fcded99fa9d6f6f9387e286", "63457f81415bc4a71391f2c96fba3d2b", kGADSimulatorID ]
            cellBannerView?.delegate = self
            cellBannerView?.adUnitID = "ca-app-pub-1883187213556981/9918972222"
            cellBannerView?.rootViewController = self
            cellBannerView?.load(request)
            
            return cell
            
            
        }else{
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "facebookCell", for: indexPath)
            
            return cell
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/9
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 1){
            
            self.performSegue(withIdentifier: "facebookSegue", sender: self)
        }else if (indexPath.row == 2){
            
            self.performSegue(withIdentifier: "twitterSegue", sender: self)
        }else if (indexPath.row == 3){
            
            self.performSegue(withIdentifier: "instagramSegue", sender: self)
        }else if (indexPath.row == 4){
            
            self.performSegue(withIdentifier: "youtubeSegue", sender: self)
        }else if (indexPath.row == 5){
            
            self.performSegue(withIdentifier: "imgurSegue", sender: self)
        }else if (indexPath.row == 6){
            
            self.performSegue(withIdentifier: "twitchSegue", sender: self)
        }else if (indexPath.row == 7){
            
            self.performSegue(withIdentifier: "tumblrSegue", sender: self)
        }else if (indexPath.row == 8){
            
            self.performSegue(withIdentifier: "redditSegue", sender: self)
        }else if (indexPath.row == 9){
            
            self.performSegue(withIdentifier: "pinterestSegue", sender: self)
        }

    }
    
}
