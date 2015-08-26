//
//  ShareViewController.swift
//  ReadIt
//
//  Created by rajashrk on 8/24/15.
//  Copyright (c) 2015 rajashrk. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController:SLComposeServiceViewController {
    
    var linkTitle : String!
    var link : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
        
    }
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func presentationAnimationDidFinish() {
        var item : NSExtensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
        var itemProvider : NSItemProvider = item.attachments?[0] as! NSItemProvider
        var contentType = kUTTypeURL as NSString
        for attachment in item.attachments  as! [NSItemProvider] {
            if attachment.hasItemConformingToTypeIdentifier(contentType as String){
                
                itemProvider.loadItemForTypeIdentifier("public.url", options:nil) { urlItem, error in
                    
                    var url : NSURL = urlItem as! NSURL
                    self.linkTitle = self.textView.text
                    self.link = url.absoluteString
                }
                
                
            }
        }
        
        
    }
    
    override func didSelectPost() {
        
        var err : NSError?
        var dictionary : Dictionary = [ "title":self.linkTitle!, "link":self.link! ]
        var userDefault = NSUserDefaults(suiteName:"group.IFReaderIdentifier")
        
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("group.IFReaderIdentifier")
        configuration.sharedContainerIdentifier = "group.IFReaderIdentifier"
        let session =  NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        var urlString = "http://readit.thoughtworks.com/resources"
        var request = NSMutableURLRequest(URL:NSURL(string:urlString)!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request)
        task.resume()
        
        self.extensionContext!.completeRequestReturningItems([], completionHandler:nil)
        
    }
    
    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
