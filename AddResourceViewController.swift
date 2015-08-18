//
//  AddResourceViewController.swift
//  HybridReadItIOS
//
//  Created by rajashrk on 8/17/15.
//  Copyright (c) 2015 rajashrk. All rights reserved.
//

import Foundation
import UIKit

class AddResourceViewController :	UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
       self.navigationController?.navigationBar.topItem?.title = "Add Resource"
        
        var resourceListHTML = NSBundle.mainBundle().pathForResource("AddResource", ofType: "html")
        var contentString = NSString(contentsOfFile: resourceListHTML!, encoding: NSUTF8StringEncoding, error:nil);
        var url = NSURL(fileURLWithPath:resourceListHTML!)
        
        var request = NSURLRequest(URL: url!)
        webView.loadHTMLString(contentString! as String, baseURL: url!)
        
    }
    
    @IBAction func addResource(sender: AnyObject) {
      
      println("Done clicked")
      var responce  = self.webView.stringByEvaluatingJavaScriptFromString("getResource()")
      
      if let result = responce {
        println(result)
        if let json =  NSJSONSerialization.JSONObjectWithData(result.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: nil) as? NSDictionary {
                post(json)
            }
        }
       
    
       self.webView.stringByEvaluatingJavaScriptFromString("clearAll()")
        
    }
    

    func post(jsonData : NSDictionary) {
        
        var urlString = "http://readit.thoughtworks.com/resources"
        var request = NSMutableURLRequest(URL:NSURL(string:urlString)!)
        var session = NSURLSession.sharedSession();
        request.HTTPMethod = "POST"
        
        
        var err : NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonData, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if data != nil {
                var json = NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers, error:nil) as? NSDictionary
                if err != nil{
                    println(err?.localizedDescription)
                    return
                }
                if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode != 201 {
                        self.showAlert("Oops", message:String(httpResponse.statusCode))
                        return
                    }
                }
            }
            
            if error != nil{
                self.showAlert("Oops", message:error.localizedDescription)
                return
            }
            
        }
        
    }
    
    
    func showAlert(title : String, message : String)
    {
        var alert = UIAlertView(title:title, message:message, delegate: nil, cancelButtonTitle: "OK")
        alert.show();
    }


}