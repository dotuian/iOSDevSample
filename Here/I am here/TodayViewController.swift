//
//  TodayViewController.swift
//  I am here
//
//  Created by 鐘紀偉 on 15/4/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit
import NotificationCenter
import MapKit
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate, MKMapViewDelegate  {
    // 位置文字信息
    @IBOutlet weak var locationLabel: UILabel!
    // 地图视图
    @IBOutlet var mapView: MKMapView!

    var locationManager : CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        initSubViews()
    }

    func initSubViews(){
        // 设置插件内容的大小
        self.preferredContentSize = CGSizeMake(self.view.bounds.width, CGFloat(400))

        // 定位权限的获取
        self.locationManager = CLLocationManager()
        if (self.locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            let status = CLLocationManager.authorizationStatus()

            switch status {
            case CLAuthorizationStatus.Denied:
                println("没有定位权限!")
            case CLAuthorizationStatus.AuthorizedWhenInUse,
                 CLAuthorizationStatus.AuthorizedAlways:
                println()
            case CLAuthorizationStatus.NotDetermined:
                // 没有指定权限的时候,向用户请求定位权限
                self.locationManager.requestAlwaysAuthorization()
            default:
                println()
            }
        } else {

        }

        // 地图视图的类型
        self.mapView.mapType = MKMapType.Standard
        // 地图视图的代理
        self.mapView.delegate = self
        // 设置显示用户的位置
        if CLLocationManager.locationServicesEnabled() {
            self.mapView.showsUserLocation = true
        }


        self.locationManager.delegate = self
        // 请求获取位置
        self.locationManager.startUpdatingLocation()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets{
        var insets = defaultMarginInsets
        insets.bottom = 0
        insets.left = 0

        return insets
    }

    // CLLocationManager获取位置信息完成时,调用
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // 停止定位
        manager.stopUpdatingLocation()

        // 获取最新的位置信息
        var locationArray = locations as NSArray
        var location = locationArray.lastObject as! CLLocation
    }

    // Tells the delegate that the location manager was unable to retrieve a location value.
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        manager.stopUpdatingLocation()

        // "The operation couldn’t be completed" 的解决办法: 重置模拟器的内容和设置,重新启动APP
        // http://stackoverflow.com/questions/3110708/cllocationmanager-on-iphone-simulator-fails-with-kclerrordomain-code-0
        if error != nil {
            println("location failure: \(error.localizedDescription)")
        }
    }

    // 用户位置更新后执行
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        // 当前位置信息
        let location = userLocation.location

        // 更新MapView的显示
        self.setMapViewRegion(location)

        // 通过经纬度获取地址信息
        let strLocation = LocationUtils.reverseLocation(location)
        println(strLocation!)

        self.locationLabel.text = strLocation
        self.locationLabel.textAlignment = NSTextAlignment.Left
        self.locationLabel.textColor = UIColor.whiteColor()
        self.locationLabel.font = UIFont.systemFontOfSize(13)
    }


    // 设置地图视图的显示区域
    func setMapViewRegion(location : CLLocation) {
        // 地理位置
        var coordinate = location.coordinate
        // 显示范围精度
        let coordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        // 显示区域
        let coordinateRegion = MKCoordinateRegionMake(coordinate, coordinateSpan)
        // 设置地图的显示区域
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}
