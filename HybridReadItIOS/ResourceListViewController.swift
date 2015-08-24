//
//  ViewController.swift
//  HybridReadItIOS
//
//  Created by rajashrk on 8/12/15.
//  Copyright (c) 2015 rajashrk. All rights reserved.
//

import UIKit
import WebKit
class ResourceListViewController: UIViewController {

    
    @IBOutlet weak var resourceWebView: UIWebView!
    var jsonResources = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController?.navigationBar.topItem?.title = "ReadIt"
        
         var resourceListHTML = NSBundle.mainBundle().pathForResource("listResources", ofType: "html")
         var contentString = NSString(contentsOfFile: resourceListHTML!, encoding: NSUTF8StringEncoding, error:nil);
         var url = NSURL(fileURLWithPath:resourceListHTML!)
        
         var request = NSURLRequest(URL: url!)
         resourceWebView.loadHTMLString(contentString! as String, baseURL: url!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        loadResources();
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        var CancelBarButton = UIBarButtonItem(title:"Cancel", style:UIBarButtonItemStyle.Plain, target:self, action:Selector("loadResources"))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = CancelBarButton;
        
    }
    
    func loadResources()
    {
        let urlString = "http://readit.thoughtworks.com/resources"
        let url = NSURL(string: urlString);
        let request = NSURLRequest(URL: url!);
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if data != nil  {
                
                if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray {
                    self.jsonResources = jsonResult
                    self.resourceWebView.reload();
                }
                
            }
            if error != nil{
                
                var alert = UIAlertView(title:"Oops", message:error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                
                alert.show();
            }
            
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    
}

extension ResourceListViewController : UIWebViewDelegate {

    func webViewDidFinishLoad(webView: UIWebView){
        
        var data =  NSJSONSerialization.dataWithJSONObject(self.jsonResources, options: nil, error: nil)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)as! String
        let function = "loadResourceJSon" + "(" + string + ")"
        let response = self.resourceWebView.stringByEvaluatingJavaScriptFromString(function);
    }
}



