//
//  WebViewController.swift
//  TravelTheWorld
//
//  Created by seodonghyun on 2017. 8. 29..
//  Copyright © 2017년 seodonghyun. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    var country: Country!
    var url: URL!
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //first we will create a NSURL with the url that we want to load in the webview
        //let url = URL(string: country.wikiUrl ??  "");
        //now we need an NSURLRequest and it will take the NSURL
        let request = URLRequest(url: url!);
        webView.loadRequest(request);
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
