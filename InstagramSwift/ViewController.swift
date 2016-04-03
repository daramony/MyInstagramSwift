//
//  ViewController.swift
//  InstagramSwift
//
//  Created by Daramony on 4/2/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var clientId : String?
    var clientSecret : String?
    var redirectURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestWebview()
    }
    
    private func requestWebview() {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary.init(contentsOfFile: path!)
        clientId = dict!["InstagramAppClientId"] as! String!
        clientSecret = dict!["InstagramAppClientSecret"] as! String!
        redirectURL = dict!["InstagramAppRedirectURL"] as! String!
        
        let urlString = "https://api.instagram.com/oauth/authorize/?client_id=\(clientId!)&redirect_uri=\(redirectURL!)&response_type=code"
        let url = NSURL.init(string: urlString)
        let request = NSURLRequest.init(URL: url!)
        self.webview.loadRequest(request)
        self.webview.delegate = self
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL?.host == "codegerms.com" {
            let query = request.URL?.query
            let splitedQuery = query!.componentsSeparatedByString("=")
            
            if splitedQuery.first == "code" {
                let code = splitedQuery.last
                requestAccess(code!)
            }
            self.statusLabel.hidden = false
            return false
        }
        self.statusLabel.hidden = true
        return true
    }
    
    
    func requestAccess(code: String) {
        
        let data = "client_id=\(clientId!)&client_secret=\(clientSecret!)&grant_type=authorization_code&redirect_uri=\(redirectURL!)&code=\(code)"
        let urlString = "https://api.instagram.com/oauth/access_token"
        let url = NSURL.init(string: urlString)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            do {
                let dataDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
                if let accessToken = dataDict["access_token"] as! String! {
                    DataManager.sharedInstance.accessToken = accessToken
                    self.performSegueWithIdentifier("FeedSegue", sender: self)
                }
            } catch let error {
                print("json error: \(error)")
            }
        }
        dataTask.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

