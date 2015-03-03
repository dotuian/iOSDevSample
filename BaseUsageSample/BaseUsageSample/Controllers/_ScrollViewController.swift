//
//  _ScrollViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/19.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit


class _ScrollViewController: UITableViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("self.view.frame  = \(self.view.frame)")
        println("self.view.bounds = \(self.view.bounds)")
        
        var scrollView = UIScrollView()
        scrollView.frame = CGRectMake(0, 0, self.view.bounds.width * 5, 300)
        scrollView.contentSize = CGSizeMake(self.view.bounds.width * 5, 300)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        for var index=0 ; index < 5; index++ {
            var imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(index) * self.view.bounds.width, 0, self.view.bounds.width, 300)
            imageView.image = UIImage(named: NSString(format: "image-%d.jpg", index + 1))
            
            scrollView.addSubview(imageView)
        }
        
        self.tableView.tableHeaderView = scrollView
        
        
        // UIPageControl
        var pageControl = UIPageControl()
        pageControl.frame = CGRectMake((self.view.bounds.width - 50) / 2, 250 , 50, 30)
        pageControl.numberOfPages = 5
        pageControl.tag = 101
        self.view.addSubview(pageControl)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        
        cell?.textLabel!.text = NSString(format: "row %d", indexPath.row + 1 )
        
        return cell!
    }
    
    
    // any offset changes
    override func scrollViewDidScroll(scrollView: UIScrollView) {
    }

    // any zoom scale changes
    override func scrollViewDidZoom(scrollView: UIScrollView) {
    
    }
    
    // called on start of dragging (may require some time and or distance to move)
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    
    }
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest

    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
    
    }
    
    // called on finger up as we are moving
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
    
    }
    
    // called when scroll view grinds to a halt
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if scrollView.isMemberOfClass(UIScrollView) {
            println(scrollView.contentOffset)
            
            var pageSize = Int(scrollView.contentOffset.x / self.view.bounds.width)
            
            var pageControl = self.view.viewWithTag(101) as UIPageControl
            pageControl.currentPage = pageSize
        
        }
        
    }
    
    // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    override func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    
    }
    
    // return a view that will be scaled. if delegate returns nil, nothing happens
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    
        return nil
    }

    // called before the scroll view begins zooming its content
    override func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        
    }
    
    // scale between minimum and maximum. called after any 'bounce' animations
    override func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat){
        
    }
    
    // return a yes if you want to scroll to the top. if not defined, assumes YES
    override func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    
    // called when scrolling animation finished. may be called immediately if already at top
    override func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    }

    
}
