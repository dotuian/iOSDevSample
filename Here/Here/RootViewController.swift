//
//  RootViewController.swift
//  Here
//
//  Created by 鐘紀偉 on 15/4/7.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class RootViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager : CLLocationManager!

    var mapView : MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubViews()
        self.loadData()
    }

    func initSubViews(){
        self.view.backgroundColor = UIColor.whiteColor()

        //==============================================================
        // 工具栏
        let settingItem = UIBarButtonItem(image: UIImage(named: "settings-25"), style: UIBarButtonItemStyle.Done, target: self, action: "hanlderSetting")
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        self.toolbarItems = [spaceItem, settingItem]

        //==============================================================
        // 定位服务
        self.locationManager = CLLocationManager()
        // 定位服务是否可用
        if CLLocationManager.locationServicesEnabled() {
            println("定位服务可用")
            // 设置代理
            self.locationManager.delegate = self
            // 请求定位权限
            // locationManager.requestAlwaysAuthorization()
            self.requestAlwaysAuthorization()
            // 定位精确度
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            // 开始定位
            self.locationManager.startUpdatingLocation()
        } else {
            println("定位服务不可用")
        }

        //==============================================================
        // 地图View
        self.mapView = MKMapView(frame: self.view.bounds)
        // 是否显示当前用户位置
        self.mapView.showsUserLocation = true
        // 地图类型
        self.mapView.mapType = MKMapType.Standard
        // 经纬度
        let centerCoordinate2D = CLLocationCoordinate2D(latitude: 35.6020691, longitude: 139.8753269)
        // 显示范围精度
        let coordinateSpan = MKCoordinateSpanMake(1, 1)
        // 显示区域
        let coordinateRegion = MKCoordinateRegionMake(centerCoordinate2D, coordinateSpan)
        // 设置地图的显示区域
        self.mapView.setRegion(coordinateRegion, animated: true)
        // 设置代理
        self.mapView.delegate = self
        // 添加到子视图
        self.view.addSubview(mapView)
    }

    func loadData(){
        // 加载地图类型数据
        // Standard : 标准
        // Satellite: 卫星
        // Hybrid   : 混合
        switch(userDefaults.integerForKey(Constants.SETTING_MAP_TYPE)) {
        case 0:
            self.mapView.mapType =  MKMapType.Standard
        case 1:
            self.mapView.mapType =  MKMapType.Satellite
        case 2:
            self.mapView.mapType =  MKMapType.Hybrid
        default :
            self.mapView.mapType = MKMapType.Standard
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 显示工具栏
        self.navigationController?.toolbarHidden = false

        self.loadData()
    }

    func hanlderSetting(){
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }

    func requestAlwaysAuthorization(){
        // iOS8.0
        if self.locationManager.respondsToSelector("requestAlwaysAuthorization") {
            // 获取设备定位权限状态
            let status = CLLocationManager.authorizationStatus()

            switch status {
            case CLAuthorizationStatus.Denied, CLAuthorizationStatus.AuthorizedWhenInUse :
                let title = (status == CLAuthorizationStatus.Denied) ? "Location services are off" : "Background location is not enabled";
                let message = "To use background location you must turn on 'Always' in the Location Services Settings";

                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                let settingAction = UIAlertAction(title: "Setting", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction!) -> Void in
                    // 打开应用程序设置页面
                    let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    UIApplication.sharedApplication().openURL(settingUrl!)
                })

                alertController.addAction(cancelAction)
                alertController.addAction(settingAction)

                // 显示对话框
                self.presentViewController(alertController, animated: true, completion: nil)

            case CLAuthorizationStatus.NotDetermined : // 定位权限还没有决定的情况下
                self.locationManager.requestAlwaysAuthorization()

            default:
                println()
            }
        }
    }


    //====================================
    // CLLocationManagerDelegate
    //====================================
    // Tells the delegate that the authorization status for the application changed.
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

    }

    // Tells the delegate that the location manager was unable to retrieve a location value.
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()

        // "The operation couldn’t be completed" 的解决办法: 重置模拟器的内容和设置,重新启动APP
        // http://stackoverflow.com/questions/3110708/cllocationmanager-on-iphone-simulator-fails-with-kclerrordomain-code-0
        if error != nil {
            println("location failure: \(error.localizedDescription)")
        }
    }

    // Tells the delegate that new location data is available.
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // 停止定位
        manager.stopUpdatingLocation()

        // 获取最新的位置信息
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coordinate: CLLocationCoordinate2D = locationObj.coordinate
        println("时间 \(NSDate()) 经度: \(coordinate.longitude)  纬度:\(coordinate.latitude)  高度:\(locationObj.altitude)")


        // 通过经纬度获取地址信息
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationObj, completionHandler: { (placemarks: [AnyObject]!, error : NSError!) -> Void in

            for placemark in placemarks {
                if let place = placemark as? CLPlacemark {
                    println("  \(place.name)")
                    println("  \(place.thoroughfare)")
                    println("  \(place.subThoroughfare)")
                    println("  \(place.locality)")
                    println("  \(place.subLocality)")
                    println("  \(place.country)")
                }
            }
        })
    }

    //====================================
    // MKMapViewDelegate
    //====================================
    // 地图显示区域将要改变
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool){
        println("regionWillChangeAnimated")
    }

    // 地图显示区域已经改变
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool){
        println("regionDidChangeAnimated")
    }

    // 将要开始加载地图
    func mapViewWillStartLoadingMap(mapView: MKMapView!){
        println("mapViewWillStartLoadingMap")
    }

    // 地图加载已经完成
    func mapViewDidFinishLoadingMap(mapView: MKMapView!){
        println("mapViewDidFinishLoadingMap")
    }

    // 地图加载失败
    func mapViewDidFailLoadingMap(mapView: MKMapView!, withError error: NSError!){
        println("mapViewDidFailLoadingMap")
    }

    // 返回标注视图
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        return nil
    }

    // 更新当前位置
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {

    }

    // 选中标注地图
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {

    }



}