//
//  PlayerVC.swift
//  musicsearch
//
//  Created by Javid Poornasir on 7/7/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit
import AVKit
import WebKit
import AVFoundation

class PlayerVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var videoContainer: UIView!
    var webkitView: WKWebView!
    var theURL = String()
    var lyricsExist = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingLabel.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if lyricsExist {
            loadingLabel.text = "Your webpage is currently loading"
            let bounds = CGRect(x: 0, y: 0, width: videoContainer.frame.size.width, height: videoContainer.frame.size.height)
            webkitView = WKWebView(frame: bounds, configuration: self.getWebKitViewConfiguration())
            videoContainer.addSubview(webkitView)
            self.webkitView.navigationDelegate = self
            
            self.webkitView.load(NSURLRequest(url: NSURL(string: self.theURL)! as URL) as URLRequest)
        } else {
            loadingLabel.text = "No lyrics currently available"
        }
    }
    
    func getWebKitViewConfiguration() -> WKWebViewConfiguration {
        let webViewConfiguration: WKWebViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        webViewConfiguration.allowsAirPlayForMediaPlayback = true
        webViewConfiguration.suppressesIncrementalRendering = false
        return webViewConfiguration
    }
    
    @IBAction func goBackBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loadingLabel.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
}
