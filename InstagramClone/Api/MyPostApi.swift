//
//  MyPostApi.swift
//  InstagramClone
//
//  Created by Tochi on 23/02/2020.
//  Copyright © 2020 martins. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostApi {
    var REF_MY_POST = Database.database().reference().child("post")
}
