//
//  _ImagePickerViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

// UIImageView的常用操作：http://my.oschina.net/plumsoft/blog/76128


import Foundation
import UIKit

class _ImagePickerViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {
    
    var imageItem : UIBarButtonItem!
    
    var picker : UIImagePickerController!

    var popover : UIPopoverController!
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        // 图片选取控制管理器
        picker = UIImagePickerController()
        picker.delegate = self
        
        // 导航菜单
        imageItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "selectImages")
        self.navigationItem.rightBarButtonItem = imageItem
        
        scrollView = UIScrollView()
        scrollView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        scrollView.userInteractionEnabled = true
        
        scrollView.maximumZoomScale=4.0;//最大倍率（默认倍率）
        scrollView.minimumZoomScale=1.0;//最小倍率（默认倍率）
        scrollView.decelerationRate=1.0;//减速倍率（默认倍率）
        scrollView.delegate=self;
        
        //UIView 中有一个autoresizingMask的属性，它对应的是一个枚举的值（如下），属性的意思就是自动调整子控件与父控件中间的位置，宽高
        //UIViewAutoresizingNone  就是不自动调整。
        //UIViewAutoresizingFlexibleLeftMargin  就是自动调整与superView左边的距离，也就是说，与superView右边的距离不变。
        //UIViewAutoresizingFlexibleRightMargin 就是自动调整与superView的右边距离，也就是说，与superView左边的距离不变。
        //UIViewAutoresizingFlexibleTopMargin
        //UIViewAutoresizingFlexibleBottomMargin
        //UIViewAutoresizingFlexibleWidth
        //UIViewAutoresizingFlexibleHeight
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleHeight

        
        //用于显示图片
        imageView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        //调整该视图与父视图的位置
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleHeight

        //设置图片的显示方式，如居中、居右，是否缩放等
        // 凡是没有带Scale的，当图片尺寸超过 ImageView尺寸时，只有部分显示在ImageView中
        //
        // UIViewContentModeScaleToFill  属性会导致图片变形
        // UIViewContentModeScaleAspectFit 保证图片比例不变，而且全部显示在ImageView中,意味着ImageView会有部分空白
        // UIViewContentModeScaleAspectFill 会证图片比例不变，但是是填充整个ImageView的，可能只有部分图片显示出来
        // UIViewContentModeRedraw
        // UIViewContentModeCenter
        // UIViewContentModeTop
        // UIViewContentModeBottom
        // UIViewContentModeLeft
        // UIViewContentModeRight
        // UIViewContentModeTopLeft
        // UIViewContentModeTopRight
        // UIViewContentModeBottomLeft
        // UIViewContentModeBottomRight
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        //用户交互
        imageView.userInteractionEnabled = true

        //给UIImageView添加手势
        // 单击
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handlerSingleTapGestureRecognizer:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1 //  单击
        // 双击
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handlerDoubleTapGestureRecognizer:")
        doubleTapGestureRecognizer.numberOfTapsRequired = 2 //  双击
        
        // 用来识别单击和双击手势
        singleTapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        
        // 捏合手势
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handlerPinchGestureRecognizer:")
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "handlerRotationGestureRecognizer:")
        
        imageView.addGestureRecognizer(singleTapGestureRecognizer)
        imageView.addGestureRecognizer(doubleTapGestureRecognizer)
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        imageView.addGestureRecognizer(rotationGestureRecognizer)

        
        self.scrollView.addSubview(imageView)
        
        self.view.addSubview(scrollView)
    }
    
    //=======================================
    // 手势
    //=======================================
    // 单击图片隐藏或显示导航栏
    func handlerSingleTapGestureRecognizer(tapGestureRecognizer : UITapGestureRecognizer){
        println("单击")
        
        if self.imageView.image != nil {
            let show = self.navigationController?.navigationBarHidden
            if show! {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                //self.navigationController?.setToolbarHidden(false, animated: true)
            } else {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                //self.navigationController?.setToolbarHidden(true, animated: true)
            }
        }
        
    }
    
    // 双击回到原始大小
    func handlerDoubleTapGestureRecognizer(tapGestureRecognizer : UITapGestureRecognizer){
        println("双击")
        // default is 1.0
        scrollView.setZoomScale(1.0, animated: true)
        
        self.scrollView.center = self.view.center
//        self.imageView.center = self.view.center
    }
    
    // 捏合手势
    func handlerPinchGestureRecognizer(gestureRecognizer: UIPinchGestureRecognizer) {
        let scale = gestureRecognizer.scale
        scrollView.setZoomScale(scale, animated: true)
    }
    
    
    var lastRotation = 0.0
    func handlerRotationGestureRecognizer(recognizer: UIRotationGestureRecognizer) {

        self.scrollView.center = self.view.center
        self.imageView.center = self.view.center
        
        // UIRotationGestureRecognizer.rotation  旋转角度
        // UIRotationGestureRecognizer.velocity  旋转速度，不常用


        // 弧度值为：角度＊*M_PI/180
        // UIImageView旋转
        //imageView.transform = CGAffineTransformMakeRotation(recognizer.rotation); //传入弧度值
        
        var degree : Double = Double(recognizer.rotation * 180) / M_PI
        
        println("recognizer.rotation = \(degree)")
        
        var value : Double = 0.0
        switch degree {
            case 1...90:
                value = M_PI / 2
            case 91...180:
                value = M_PI
            case 180...270:
                value = 1.5 * M_PI
            case 270...360:
                value = 2 * M_PI
            default:
                value = 0
        }
        
        recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, CGFloat(value))
        }

//       recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
        
//        let degree = ( recognizer.rotation * 180 ) / M_PI
//        if degree > 45.0 {
//            recognizer.view!.transform = CGAffineTransformMakeRotation(recognizer.rotation);
//            
//            // 重置旋转量
//            recognizer.rotation = 0.0;
//        }
        
        
        
        // self.imageView.image?.imageOrientation = UIImageOrientation.Right
        

//        UIImageOrientationUp,            // default orientation  默认方向
//        UIImageOrientationDown,          // 180 deg rotation    旋转180度
//        UIImageOrientationLeft,          // 90 deg CCW         逆时针旋转90度
//        UIImageOrientationRight,         // 90 deg CW          顺时针旋转90度
//        UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip   向上水平翻转
//        UIImageOrientationDownMirrored,  // horizontal flip    向下水平翻转
//        UIImageOrientationLeftMirrored,  // vertical flip      逆时针旋转90度，垂直翻转
//        UIImageOrientationRightMirrored, // vertical flip      顺时针旋转90度，垂直翻转

        
        
        //let transform = CGAffineTransformMakeRotation(M_PI * 0.38);
        /*关于M_PI
        #define M_PI     3.14159265358979323846264338327950288
        其实它就是圆周率的值，在这里代表弧度，相当于角度制 0-360 度，M_PI=180度
        旋转方向为：顺时针旋转
        */

        
        
        
//        recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
//        recognizer.rotation = 0
//        var label = recognizer.view as UIImageView  // creating a new UIImageView out of the rotation
//        if recognizer.state == UIGestureRecognizerState.Changed {
//            //hoverShadow(label) // add some Extra Shadow when we are rotating the new ImageView
//        }
//        else {
//            //shadow(label) // return to the original Shadow when not moving
//        }

        
    }
    
    //=======================================
    // UIScrollViewDelegate代理方法
    //=======================================
    
    // 指定缩放的UIView对象
    // return a view that will be scaled. if delegate returns nil, nothing happens
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }



    
    func selectImages(){
        var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary()
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            println("=== cancel ===")
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
        
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
            let popoverController = UIPopoverController(contentViewController: alert)
            popoverController.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    
    }
    
    // 通过照相机来选取图片
    func openCamera(){
        
        // 判断设备是否具有照相设备
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            //图片来源的类型
            //UIImagePickerControllerSourceType.PhotoLibrary
            //UIImagePickerControllerSourceType.Camera
            //UIImagePickerControllerSourceType.SavedPhotosAlbum
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            
            // 拍摄照片的清晰度，只有在照相机的模式下可用，默认为UIImagePickerControllerQualityTypeMedium
            // TypeHigh // highest quality
            // TypeMedium // medium quality, suitable for transmission via Wi-Fi
            // TypeLow // lowest quality, suitable for tranmission via cellular network
            // Type640x480 // VGA quality
            picker.videoQuality = UIImagePickerControllerQualityType.TypeHigh
            
            
            //设置照相机的模式
            // UIImagePickerControllerCameraCaptureMode.Photo 拍照模式(默认状态)
            // UIImagePickerControllerCameraCaptureMode.Video 录视频模式
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
            
            
            //设置引用那个摄像头，前置还是后置
            // UIImagePickerControllerCameraDevice.Front // 前置摄像头
            // UIImagePickerControllerCameraDevice.Rear  // 后置摄像头
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            
            
            //设置闪光灯模式
            // UIImagePickerControllerCameraFlashMode.On  开
            // UIImagePickerControllerCameraFlashMode.Off 关
            // UIImagePickerControllerCameraFlashMode.Auto 自动
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
            
            
            // 确定在Picker中可以执行的功能，如录像、拍照
            // UIImagePickerControllerMediaType
            // public.movie（录像） public.image（拍照）
            picker.mediaTypes = ["public.movie", "public.image"]
            
            
            picker.videoMaximumDuration = 30.0
            
            // 是否允许对已获得的图片进行编辑（默认为NO）
            picker.allowsEditing = true

            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.presentViewController(picker, animated: true, completion: nil)
            } else {
                
                popover = UIPopoverController(contentViewController: picker)
                popover.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
            
        } else {

            let alertView = UIAlertController(title: "提示", message: "该设备不具备照相功能", preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
            }
            
            alertView.addAction(cancelAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    
    // 打开相册来选取图片
    func openGallary(){
        
        //图片来源的类型
        //UIImagePickerControllerSourceType.PhotoLibrary
        //UIImagePickerControllerSourceType.Camera
        //UIImagePickerControllerSourceType.SavedPhotosAlbum
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        
        // 确定在Picker中可以执行的功能，如录像、拍照
        // UIImagePickerControllerMediaType
        // public.movie（录像） public.image（拍照）
        picker.mediaTypes = ["public.movie", "public.image"]
        
        // 是否允许对已获得的图片进行编辑（默认为NO）
        //picker.allowsEditing = true
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker)
            popover!.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }

    // 
    func saveImageToPhotoLibray(info : [NSObject : AnyObject]){
        var image: UIImage?
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            // 编辑过的照片
            image = img
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // 未被编辑的原始照片
            image = img
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    
    //
    func saveVideoToVideoLibray(info : [NSObject : AnyObject]){
        var url = info[UIImagePickerControllerMediaURL] as? NSURL
        var videoPath = url?.path
        
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil)
        }
    }
    
    
    //=======================================
    // UIImagePickerController的代理方法
    //=======================================
    
    // 选取图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        println(" image is picked !")

        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // info[UIImagePickerControllerOriginalImage] as? UIImage : 获取原始图片
        // info[UIImagePickerControllerEditedImage]   as? UIImage : 获取编辑之后的图片
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        
        // 将照片存入相册
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        
        // 保存图片到沙盒中
        let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory = storeFilePath[0] as String
        
        
        let format = NSDateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let imageFullName = format.stringFromDate(NSDate()) + ".jpg"
        
        var imagePath = doucumentsDirectiory.stringByAppendingPathComponent(imageFullName)
        
        //var result:Bool = UIImagePNGRepresentation(image).writeToFile(imagePath, atomically:true)
        //if result == false {
        //    println("save error")
        //}
        //println(imagePath)
        
        
    }
    
    // 取消选取
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        println(" image picker cancelled ")
        
        //对于隐藏ViewController，下面的2种方式都可以
        //picker.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}