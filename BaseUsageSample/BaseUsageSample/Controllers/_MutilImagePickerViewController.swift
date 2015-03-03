//
//  _MutilImagePickerViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/19.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit


class _MutilImagePickerViewController: UIViewController, ELCImagePickerControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "selectImages")
        
        self.navigationController?.toolbarHidden = false
        self.toolbarItems = [space, addItem]
        
        
    }
    
    func selectImages (){
        
        var imagePicker = ELCImagePickerController(imagePicker: ())
        
        
        //Set the maximum number of images to select to 100
        imagePicker.maximumImagesCount = 100;
        
        //Only return the fullScreenImage, not the fullResolutionImage
        imagePicker.returnsOriginalImage = true;
        
        //Return UIimage if YES. If NO, only return asset location information
        imagePicker.returnsImage = true;
        
        //For multiple image selection, display and return order of selected images
        imagePicker.onOrder = true;
        
        //Supports image and movie types
        imagePicker.mediaTypes = [kUTTypeImage, kUTTypeMovie]
        
        // set delegate
        imagePicker.imagePickerDelegate = self;

        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /**
    * Called with the picker the images were selected from, as well as an array of dictionary's
    * containing keys for ALAssetPropertyLocation, ALAssetPropertyType,
    * UIImagePickerControllerOriginalImage, and UIImagePickerControllerReferenceURL.
    * @param picker
    * @param info An NSArray containing dictionary's with the key UIImagePickerControllerOriginalImage, which is a rotated, and sized for the screen 'default representation' of the image selected. If you want to get the original image, use the UIImagePickerControllerReferenceURL key.
    */
    func elcImagePickerController(picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if (info.count == 0) {
            return
        }
        
        var pickedImages = NSMutableArray()
        for any in info {
            let dict = any as NSMutableDictionary
            let image = dict.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            pickedImages.addObject(image)
        }
        
        println(pickedImages)

    }

    /**
    * Called when image selection was cancelled, by tapping the 'Cancel' BarButtonItem.
    */
    func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
