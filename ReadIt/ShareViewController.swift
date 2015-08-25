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
class ShareViewController: SLComposeServiceViewController {

    var linkTitle : String!
    var link : String!
    
    
    override func viewDidLoad() {
        //self.textView.text
        
        
        var item : NSExtensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
        var itemProvider : NSItemProvider = item.attachments?[0] as! NSItemProvider
        
        itemProvider.loadItemForTypeIdentifier("public.url", options:nil) { urlItem, error in
            var url : NSURL = urlItem as! NSURL
            self.linkTitle = self.textView.text
            self.link = url.absoluteString
            println(itemProvider)
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
            
        }
        
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        
        
        
        
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
