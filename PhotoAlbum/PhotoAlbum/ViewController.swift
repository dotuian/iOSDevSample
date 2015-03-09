//
//  ViewController.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {


    var imageView : UIImageView!
    var scrollView : UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.cyanColor()

        scrollView = UIScrollView(frame: CGRectMake(10, 30, self.view.bounds.width - 20, self.view.bounds.height - 40))
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
//        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

        imageView = UIImageView(frame: CGRectMake(10, 10, 200, 200))
        imageView.backgroundColor = UIColor.redColor()
        imageView.image = UIImage(named: "IMG_0042.JPG")
        imageView.userInteractionEnabled = true

//        case ScaleToFill
//        case ScaleAspectFit // contents scaled to fit with fixed aspect. remainder is transparent
//        case ScaleAspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
//        case Redraw // redraw on bounds change (calls -setNeedsDisplay)
//        case Center // contents remain same size. positioned adjusted.
//        case Top
//        case Bottom
//        case Left
//        case Right
//        case TopLeft
//        case TopRight
//        case BottomLeft
//        case BottomRight
        imageView.contentMode = UIViewContentMode.ScaleAspectFill

        scrollView.addSubview(imageView)


        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        imageView.addGestureRecognizer(tap)

        self.view.addSubview(scrollView)
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {

        scrollView.zoomScale = scale

    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func tap(tap : UITapGestureRecognizer) {
        let controller = PreviewController()
        self.presentViewController(controller, animated: false, completion: nil)
    }
}

