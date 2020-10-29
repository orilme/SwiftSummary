//
//  GyroMannager.swift
//  Customer
//
//  Created by orilme on 2020/10/22.
//  Copyright © 2020 sunny. All rights reserved.
//

import UIKit
import CoreMotion

public class GyroMannager {
    
    static var shared = GyroMannager()
    private let gyromanager = CMMotionManager()
    /// manager刷新时间间隔
    public var timestamp:CGFloat = 0.03
    /// 用于记录引用 CMMotionManager 的数量
    private var useNumber:Int = 0
    
    private init() {}
    
    func monitorDeviceMotion(index: Int) {
        useNumber += index
        if useNumber <= 0 {
            stopMotionUpdates()
        } else {
            startMotionUpdates()
        }
    }
    
    /// 开始陀螺仪
    private func startMotionUpdates() {
        if self.gyromanager.isGyroAvailable {
            if self.gyromanager.isDeviceMotionActive { return }
            self.gyromanager.deviceMotionUpdateInterval = TimeInterval(self.timestamp)
            self.gyromanager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (data, nil) in
                if let gyroData = data {
                    print("陀螺仪---Updates---0")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kCMMotionManagerUpdatesNotification"), object: self, userInfo: ["gyroData": gyroData])
                }
            }
        }
    }
    
    /// 停止陀螺仪
    private func stopMotionUpdates() {
        print("陀螺仪---stopMotionUpdates---", self.useNumber)
        if self.useNumber <= 0 {
            print("陀螺仪---stopMotionUpdates")
            self.gyromanager.stopDeviceMotionUpdates()
        }
    }
    
}
