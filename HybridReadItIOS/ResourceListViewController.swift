//
//  ViewController.swift
//  HybridReadItIOS
//
//  Created by rajashrk on 8/12/15.
//  Copyright (c) 2015 rajashrk. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore


@objc protocol ListViewProtocol : JSExport{
    
    func onItemClick(string:String);
    
}

@objc class ListViewClass : NSObject, ListViewProtocol{
    
    func onItemClick(string:String){
       let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var detailViewController  = mainStoryboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
       detailViewController.url = NSURL(string: string)
       var vc = UIApplication.sharedApplication().keyWindow?.rootViewController! as! UINavigationController?
      if let mainVc = vc {
            mainVc.pushViewController(detailViewController, animated: true)
        }
    
    }
}

class ResourceListViewController: UIViewController{

    
    @IBOutlet weak var resourceWebView: UIWebView!
    var jsonResources = NSArray()
    var context = JSContext()
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "ReadIt"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:242/255.0, green: 96/255.0, blue: 146/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        searchBar.barTintColor = UIColor(red:242/255.0, green: 96/255.0, blue: 146/255.0, alpha: 0.7)
        var resourceListHTML = NSBundle.mainBundle().pathForResource("resourceList", ofType: "html", inDirectory: "www")
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
        let urlString = "http://readit.thoughtworks.com/resources"
        loadResources(urlString);
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        var CancelBarButton = UIBarButtonItem(title:"Cancel", style:UIBarButtonItemStyle.Plain, target:self, action:Selector("loadResources"))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = CancelBarButton;
        
    }
    
    func loadResources(urlString: String)
    {
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
        let function = "onListLoad" + "(" + string + ")"
        //let function = "loadResources" + "(" + string + ")"
       
        let response = self.resourceWebView.stringByEvaluatingJavaScriptFromString(function);
        
        
        
        
        context  = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext; // Undocumented access to UIWebView's JSContext
         context.setObject(ListViewClass() , forKeyedSubscript: "ListView" )
        //self.context("ListView") = ListViewClass();
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
       if (request.URL?.scheme! == "openurl")
       {
            var detailViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
                
                let query =  request.URL?.query
                if let value = query?.componentsSeparatedByString("=")[1] {
                    detailViewController.url = NSURL(string: value)
                    self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        
        }
        return true;
    }
    

}

extension ResourceListViewController : UISearchBarDelegate{
    
     func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
         var urlString = "http://readit.thoughtworks.com/resources" + searchBar.text
         loadResources(urlString);
        
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        println(searchBar.text)
        var urlString = "http://readit.thoughtworks.com/resources"
        loadResources(urlString);
    }

}







