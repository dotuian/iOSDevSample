//
//  _PhotoKitViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/3/24.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit
import Photos

let reuseIdentifier = "CollectionViewCell"

class _PhotoKitViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    var collectionView : UICollectionView!
    var photoResult : PHFetchResult!

    var imageView : UIImageView!

    var width : CGFloat = 0.0
    var height : CGFloat = 0.0


    func getMyAblum() -> PHAssetCollection {

        let assetCollections : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Moment, subtype: PHAssetCollectionSubtype.Any, options: nil)

        var myAlbum : PHAssetCollection!
        assetCollections.enumerateObjectsUsingBlock { (album : AnyObject!, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) -> Void in

            var a = album as PHAssetCollection
            println("相册名称 :  \(a.localizedTitle)")

            myAlbum = a
        }
        return myAlbum
    }

    func getAssets(fetch : PHFetchResult) -> [PHAsset] {
        var assets = [PHAsset]()

        fetch.enumerateObjectsUsingBlock { (object : AnyObject!, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            let asset = object as PHAsset
            assets.append(asset)
        }
        return assets
    }

    func updateImageViewWithAsset(asset : PHAsset) {
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(300, 300), contentMode: PHImageContentMode.AspectFill, options: nil) { (image : UIImage!, info : [NSObject : AnyObject]!) -> Void in

            if(image != nil) {
                println("图片更新")
                self.imageView.image = image
            }
        }
    }

    func refreshPhoto(){
        // PHAssetCollection を取得します
        let myAlbum = self.getMyAblum()

        // PHAsset をフェッチします
        let assets : PHFetchResult = PHAsset.fetchAssetsInAssetCollection(myAlbum, options: nil)


        // フェッチ結果から assets を取り出します
        let assetArray = self.getAssets(assets)

        // asset を使って、UIImageView をランダムに更新します
        var index = Int(arc4random()) % assets.count

        self.updateImageViewWithAsset(assetArray[index])
    }

    override func viewDidLoad() {

        let refreshItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshPhoto")

        self.navigationItem.rightBarButtonItem = refreshItem


//        imageView = UIImageView(frame: self.view.bounds)
//        self.view.addSubview(imageView)

        // 地点
//        >>> object is PHCollectionList Adachi, Shibuya & Katsushika
//        >>> object is PHCollectionList Hubei
//        >>> object is PHCollectionList Wuhan
//        >>> object is PHCollectionList Katsushika, Adachi & Wuhan
//        >>> object is PHCollectionList nil
        photoResult = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.MomentList, subtype: PHCollectionListSubtype.Any, options: nil)

        //
        photoResult = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.Folder, subtype: PHCollectionListSubtype.Any, options: nil)

        //
//        >>> object is PHCollectionList Faces
//        >>> object is PHCollectionList Events
//        photoResult = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.SmartFolder, subtype: PHCollectionListSubtype.Any, options: nil)


//        enum PHAssetCollectionType : Int {
//            case Album
//            case SmartAlbum
//            case Moment
//        }

        photoResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album, subtype:
            PHAssetCollectionSubtype.Any, options: nil)



        photoResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Video, options: nil)


        println("photoResult.count = \(photoResult.count)")
        photoResult.enumerateObjectsUsingBlock { (object :AnyObject!, idx : Int, stop : UnsafeMutablePointer<ObjCBool>) -> Void in


            if object is PHCollectionList {
                let collection = object as PHCollectionList

                println(">>> object is PHCollectionList \(collection.localizedTitle)")

            } else if object is PHAssetCollection {
                let assetCollection = object as PHAssetCollection

                println(">>> object is PHAssetCollection \(assetCollection.localizedTitle)")

            } else if object is PHAsset {
                let asset = object as PHAsset

                println(">>> object is PHAsset  \(asset.description)")

//                PHImageManager.defaultManager().requestImageForAsset(asset: PHAsset!, targetSize: <#CGSize#>, contentMode: <#PHImageContentMode#>, options: <#PHImageRequestOptions!#>, resultHandler: <#((UIImage!, [NSObject : AnyObject]!) -> Void)!##(UIImage!, [NSObject : AnyObject]!) -> Void#>)


            }

        }





        photoResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)






        // ===========================================
        var flowLayout = UICollectionViewFlowLayout()
        //设置滚动方向，默认是垂直滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical

        // UIEdgeInsets，由函数 UIEdgeInsetsMake ( CGFloat top, CGFloat left, CGFloat bottom, CGFloat right )构造出
        // 分别表示其中的内容,标题,图片离各边的距离
        // 设置组中的内容离各边的距离
        flowLayout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)

        // The minimum spacing to use between lines of items in the grid.
        // 2行之间最小的的间距
        flowLayout.minimumLineSpacing = 0

        // The minimum spacing to use between items in the same row.
        // 同一行中,2个项目之间最小的间距
        flowLayout.minimumInteritemSpacing = 0

        // 设置UICollectionViewCell的大小z
        let column :CGFloat = 4.0
        width = self.view.bounds.width / column
        height = width
        flowLayout.itemSize = CGSize(width: width, height: height) // UICollectionViewCell的大小

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()

        // 注册UICollectionViewCell
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // 设置代理
        collectionView.dataSource = self
        collectionView.delegate = self

        self.view.addSubview(collectionView)

    }

//    // Section组的个数
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }

    // 组中项目的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoResult.count
    }

    // 渲染每个CollectionViewCell的显示
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell

        var imageView = UIImageView(frame: CGRectMake(0, 0, width-1, height-1))
        cell.contentView.addSubview(imageView)

        let asset = self.photoResult.objectAtIndex(indexPath.row) as PHAsset!
        if asset != nil {
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(width-1, height-1), contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image : UIImage!, info : [NSObject : AnyObject]!) -> Void in
                imageView.image = image

            })
        }

        return cell
    }


}