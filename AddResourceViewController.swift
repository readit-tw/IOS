//
//  AddResourceViewController.swift
//  HybridReadItIOS
//
//  Created by rajashrk on 8/17/15.
//  Copyright (c) 2015 rajashrk. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore

@objc protocol AddResourceProtocol : JSExport{
    func onSave(jsonData : String)
}

@objc class AddResourceClass: NSObject,AddResourceProtocol{
    
    var addResViewController : AddResourceViewController!
    
    init(addResViewController : AddResourceViewController) {
        self.addResViewController = addResViewController
    }
    func onSave(jsonData : String){
        
        var urlString = "http://readit.thoughtworks.com/resources"
        var request = NSMutableURLRequest(URL:NSURL(string:urlString)!)
        var session = NSURLSession.sharedSession();
        request.HTTPMethod = "POST"
        
        if let json =  NSJSONSerialization.JSONObjectWithData(jsonData.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: nil) as? NSDictionary{
            
            var err : NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(json, options: nil, error: &err)
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
        self.showAlert("Added Successfully", message:"")
    
        if addResViewController != nil {
            addResViewController.clearAll()
        }
        
        
        
    }
    
    
    func showAlert(title : String, message : String)
    {
        var alert = UIAlertView(title:title, message:message, delegate: nil, cancelButtonTitle: "OK")
        alert.show();
    }
    
    
}

class AddResourceViewController :	UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var context = JSContext()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Add Resource"
        
        var resourceListHTML = NSBundle.mainBundle().pathForResource("addResource", ofType: "html", inDirectory: "www")
        var contentString = NSString(contentsOfFile: resourceListHTML!, encoding: NSUTF8StringEncoding, error:nil);
        var url = NSURL(fileURLWithPath:resourceListHTML!)
        
        var request = NSURLRequest(URL: url!)
        webView.loadHTMLString(contentString! as String, baseURL: url!)
        
    }
    
    @IBAction func addResource(sender: AnyObject) {
        var responce  = self.webView.stringByEvaluatingJavaScriptFromString("addView.addResource()")

    }
    
    func clearAll(){
        self.webView.stringByEvaluatingJavaScriptFromString("addView.clearAll()")
    }
    
}


extension AddResourceViewController:UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView){
        
        context  =  webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext;
        context.setObject(AddResourceClass(addResViewController: self) , forKeyedSubscript: "AddResource" )
        
    }
}