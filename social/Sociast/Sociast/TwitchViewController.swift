//
//  TwitchViewController.swift
//  Sociast
//
//  Created by Zhaowen Luo on 7/25/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import UIKit

class TwitchViewController: UIViewController {

    @IBOutlet weak var twitchWebView: UIWebView!
    
    @IBAction func backBtn(_ sender: Any) {
        if twitchWebView.canGoBack{
            twitchWebView.goBack()
        }
    }
    @IBAction func forwardBtn(_ sender: Any) {
        if twitchWebView.canGoForward{
            twitchWebView.goForward()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.title = "Twitch"
        
        twitchWebView.loadRequest(URLRequest(url: URL(string: "https://m.twitch.tv")!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
