//
//  YoutubeViewController.swift
//  Sociast
//
//  Created by Zhaowen Luo on 7/25/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import UIKit

class YoutubeViewController: UIViewController {

    @IBOutlet weak var youtubeWebView: UIWebView!
    
    @IBAction func backBtn(_ sender: Any) {
        if youtubeWebView.canGoBack{
            youtubeWebView.goBack()
        }
    }
    @IBAction func forwardBtn(_ sender: Any) {
        if youtubeWebView.canGoForward{
            youtubeWebView.goForward()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.title = "Youtube"
        
        youtubeWebView.loadRequest(URLRequest(url: URL(string: "https://www.youtube.com")!))
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
