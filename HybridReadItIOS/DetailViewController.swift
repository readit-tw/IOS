//
//  DetailViewController.swift
//  HybridReadItIOS
//
//  Created by rajashrk on 8/24/15.
//  Copyright (c) 2015 rajashrk. All rights reserved.
//

import Foundation
import UIKit
class DetailViewController : UIViewController{

    @IBOutlet weak var detailWebView: UIWebView!
    var url : NSURL?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        detailWebView.frame=self.view.bounds;
        detailWebView.scalesPageToFit = true;
       // println("I detail View \(url!.absoluteString)")
        if (url != nil) {
            
            var request = NSURLRequest(URL: url!)
            detailWebView.loadRequest(request)
        }
    
    }


}

extension DetailViewController : UIWebViewDelegate{

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //println(request.URL?.absoluteString)
        
        return true;
    }
}
