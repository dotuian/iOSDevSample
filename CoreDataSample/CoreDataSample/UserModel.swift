//
//  UserModel.swift
//  CoreDataSample
//
//  Created by 鐘紀偉 on 15/3/2.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import CoreData


@objc(UserModel)
class UserModel: NSManagedObject {

    @NSManaged var username: String
    @NSManaged var password: String

    
    override var description : String {
        return "username=\(username)  password=\(password)"
    }
}
