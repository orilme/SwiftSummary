//
//  LimitsTools.swift
//  UAgent
//
//  Created by GXYJ on 2019/3/20.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import UIKit
import PhotosUI
import AVFoundation

class LimitsTools: NSObject {
    static let share = LimitsTools()

    // 判断是否开启相机权限
    func authorizeCamera(authorizeClouse:@escaping (AVAuthorizationStatus)->()){
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        // 判断当前权限
        if status == .authorized{
            // 当前为"允许"
            authorizeClouse(status)
        } else if status == .notDetermined {
            // 当前为"尚未授权"，请求授权
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    authorizeClouse(.authorized)
                } else {
                    authorizeClouse(.denied)
                }
            })
        } else {
            // 当前为"不允许"
            authorizeClouse(status)
        }
    }

    // 判断是否开启相册权限
    func authorizePhotoLibrary(authorizeClouse:@escaping (PHAuthorizationStatus)->()){
        let status = PHPhotoLibrary.authorizationStatus()
        // 判断当前权限
        if status == .authorized{
            // 当前为"允许"
            authorizeClouse(status)
        } else if status == .notDetermined {
            // 当前为"尚未授权"，请求授权
            PHPhotoLibrary.requestAuthorization({ (state) in
                if state == PHAuthorizationStatus.authorized {
                    authorizeClouse(.authorized)
                } else {
                    authorizeClouse(.denied)
                }
            })
        } else {
            // 当前为"不允许"
            authorizeClouse(status)
        }
    }



}
