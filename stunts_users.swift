//
//  stunts_users.swift
//  Stunt
//
//  Created by Casey Shimata on 4/23/17.
//  Copyright © 2017 Casey Shimata. All rights reserved.
//

import Foundation

class User {
    var _id: String?
    var username: String?
    var password: String?
    var picture_url: String?
    var motorcycle_decible: Double?
    var stunts: [String?]
    
    
    init(id: String, usrname: String, pass: String, picurl: String, decib: Double, stnts: [String]) {
        _id = id
        username = usrname
        password = pass
        picture_url = picurl
        motorcycle_decible = decib
        stunts = stnts
    }
    
}

class Stunt {
    var _id: String?
    var _user: String?
    var avg_speed: Double?
    var avg_angle: Double?
    var total_angle: Double?
    var total_time: Double?
    var total_distance: Double?
    var stunt_type: String?
    var screen_recording_url: String?
    var video_url: String?


    init(id: String, usr: String, avg_spd: Double, avg_ang: Double, tot_ang: Double, tot_tme: Double, tot_dis: Double, stnt_typ: String, scrn_rec: String, vid_url: String) {
        _id = id
        _user = usr
        avg_speed = avg_spd
        avg_angle = avg_ang
        total_angle = tot_ang
        total_time = tot_tme
        total_distance = tot_dis
        stunt_type = stnt_typ
        screen_recording_url = scrn_rec
        video_url = vid_url
    }
    
}
