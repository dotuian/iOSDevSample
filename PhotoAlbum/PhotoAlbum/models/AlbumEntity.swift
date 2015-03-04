//
//  AlbumEntity.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import CoreData


@objc(AlbumEntity)
class AlbumEntity: NSManagedObject {

    @NSManaged var albumName: String
    @NSManaged var albumType: String

}
