//
//  UserInfoModel.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/5.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class UserInfoModel: BaseModel {
    var user: user?
    var extra: extra?
    var log_pb: log_pb?
}

class user: BaseModel {
    var total_favorited: UInt?
    var avatar_300x300: avatar_300x300?
    var province: String?
    var avatar_larger: avatar_larger?
    var city: String?
    var nickname: String?
    var cover_url: [cover_url]?
    var favoriting_count: UInt?
    var following_count: UInt?
    var location: String?
    var followers_detail: [followers_detail]?
    var avatar_168x168: avatar_168x168?
    var gender: UInt?
    var avatar_thumb: avatar_thumb?
    var uid: String?
    var avatar_medium: avatar_medium?
    var follower_count: UInt?
    var signature: String?
    var aweme_count: UInt?
    var short_id: String?
}

class avatar_300x300: BaseModel {
    var uri: String?
    var url_list: [String]?
}

class avatar_larger: BaseModel {
    var uri: String?
    var url_list: [String]?
}

class cover_url: BaseModel {
    var uri: String?
    var url_list: [String]?
}

class followers_detail: BaseModel {
    var icon: String?
    var fans_count: UInt?
    var open_url: String?
    var apple_id: String?
    var download_url: String?
    var package_name: String?
    var app_name: String?
    var name: String?
}

class avatar_168x168: BaseModel {
    var uri: String?
    var url_list: [String]?
}

class avatar_thumb: BaseModel {
    var uri: String?
    var url_list: [String]?
}

class avatar_medium: BaseModel {
    var uri: String?
    var url_list: [String]?
}

class extra: BaseModel {
    var now: UInt?
    var logid: String?
}

class log_pb: BaseModel {
    var impr_id: String?
}

