//
//  FacebookViewController.swift
//  Sociast
//
//  Created by Zhaowen Luo on 7/25/17.
//  Copyright © 2017 Zhaowen Luo. All rights reserved.
//

import UIKit

class FacebookViewController: UIViewController {

    
    @IBOutlet weak var facebookWebView: UIWebView!
    
    @IBAction func backBtn(_ sender: Any) {
        
        if facebookWebView.canGoBack {
        
            facebookWebView.goBack()
        
        }
    }
   
    @IBAction func forwardBtn(_ sender: Any) {
        
        if facebookWebView.canGoForward{
            facebookWebView.goForward()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "Facebook"
        
        facebookWebView.loadRequest(URLRequest(url: URL(string: "https://m.facebook.com")!))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        facebookWebView.scrollView.contentInset = UIEdgeInsets.zero;
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
