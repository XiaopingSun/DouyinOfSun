//
//  AwemeModel.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/5.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class AwemeModel: BaseModel {
    var status_code: Int?
    var min_cursor: UInt?
    var max_cursor: UInt?
    var has_more: Int?
    var aweme_list: [aweme_list]?
    var extra: extra?
    var log_pb: log_pb?
}

class aweme_list: BaseModel {
    var aweme_id: String?
    var create_time: UInt?
    var author: author?
    var music: music?
    var video: video?
    var share_url: String?
    var statistics: statistics?
    var status: status?
    var rate: CGFloat?
    var is_top: Int?
    var label_top: label_top?
    var share_info: share_info?
    var distance: String?
    var is_vr: Bool?
    var is_ads: Bool?
    var duration: Int?
    var aweme_type: Int?
    var is_fantasy: Bool?
    var author_user_id: UInt?
    var region: String?
    var vr_type: Int?
    var desc: String?
}

class author: BaseModel {
    var total_favorited: UInt?
    var avatar_300x300: avatar_300x300?
    var province: String?
    var avatar_larger: avatar_larger?
    var city: String?
    var nickname: String?
    var cover_url: cover_url?
    var favoriting_count: UInt?
    var following_count: UInt?
    var location: String?
    var followers_detail: [followers_detail]?
    var avatar_168x168: avatar_168x168?
    var gender: UInt?
    var avatar_thumb: avatar_thumb?
    var uid: String?
    var avatar_medium: [avatar_medium]?
    var follower_count: UInt?
    var signature: String?
    var aweme_count: UInt?
}

class music: BaseModel {
    var id: UInt?
    var title: String?
    var author: String?
    var album: String?
    var cover_hd: cover_hd?
    var cover_large: cover_large?
    var cover_medium: cover_medium?
    var cover_thumb: cover_thumb?
    var play_url: play_url?
    var duration: UInt?
    var user_count: UInt?
    var effects_data: effects_data?
    var owner_id: String?
    var owner_nickname: String?
    var audio_track: audio_track?
    var is_original: Bool?
    var mid: UInt?
    var author_deleted: Bool?
    var is_del_video: Bool?
    var is_video_self_see: Bool?
}

class cover_hd: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class cover_large: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class cover_medium: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class cover_thumb: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class play_url: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class effects_data: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class audio_track: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class video: BaseModel {
    var play_addr: play_addr?
    var cover: cover?
    var width: CGFloat?
    var height: CGFloat?
    var dynamic_cover: dynamic_cover?
    var origin_cover: origin_cover?
    var ratio: String?
    var download_addr: download_addr?
    var has_watermark: Bool?
    var play_addr_lowbr: play_addr_lowbr?
    var bit_rate: [bit_rate]?
    var duration: UInt?
    var is_h265: Int?
}

class play_addr: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
    var url_key: String?
}

class cover: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class dynamic_cover: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class origin_cover: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class download_addr: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
    var url_key: String?
}

class play_addr_lowbr: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
    var url_key: String?
}

class bit_rate: BaseModel {
    var gear_name: String?
    var quality_type: Int?
    var bit_rate: UInt?
    var play_addr: play_addr?
    var is_h265: Int?
}

class statistics: BaseModel {
    var aweme_id: String?
    var comment_count: Int?
    var digg_count: Int?
    var play_count: UInt?
    var share_count: Int?
    var forward_count: UInt?
}

class status: BaseModel {
    var aweme_id: String?
    var is_delete: Bool?
    var allow_share: Bool?
    var allow_comment: Bool?
    var is_private: Bool?
    var with_goods: Bool?
    var private_status: Int?
    var with_fusion_goods: Bool?
    var in_reviewing: Bool?
    var reviewed: Int?
    var self_see: Bool?
    var is_prohibited: Bool?
    var download_status: Int?
}

class label_top: BaseModel {
    var uri: String?
    var url_list: [String]?
    var width: CGFloat?
    var height: CGFloat?
}

class share_info: BaseModel {
    var share_url: String?
    var share_weibo_desc: String?
    var share_desc: String?
    var share_title: String?
    var manage_goods_url: String?
    var bool_persist: Int?
    var goods_rec_url: String?
    var share_title_myself: String?
    var share_title_other: String?
    var share_link_desc: String?
    var share_signature_url: String?
    var share_signature_desc: String?
    var share_quote: String?
}

