//
//  ViewController.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var button : UIButton!
    var imageView1 : UIImageView!
    var imageView2 : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "buttonItem")
        self.navigationItem.rightBarButtonItem = buttonItem

        self.view.backgroundColor = UIColor.whiteColor()

        imageView1 = UIImageView(frame: CGRectMake(0, 100, 100, 100))
        imageView1.image = UIImage(named: "keep_dry-50.png")

        imageView2 = UIImageView(frame: CGRectMake(0, 100, 100, 100))
        imageView2.image = UIImage(named: "Overlay@2x.png")

        self.view.addSubview(imageView1)
        self.view.addSubview(imageView2)
    }

    func buttonItem(){

        imageView2.hidden = !imageView2.hidden

    }


}

