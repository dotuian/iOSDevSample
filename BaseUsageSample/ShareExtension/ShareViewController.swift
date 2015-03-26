//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 鐘紀偉 on 15/3/24.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        println("===  isContentValid")

        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        println("===  didSelectPost")
    }

    override func configurationItems() -> [AnyObject]! {
        println("===  configurationItems")


        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return NSArray()
    }

}
