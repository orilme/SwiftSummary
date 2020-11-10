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
    /// manager刷新时间间隔（采样频率设置为比屏幕刷新频率1/60稍小）
    public var timestamp:CGFloat = 0.016
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
            if self.gyromanager.isGyroActive { return }
            self.gyromanager.gyroUpdateInterval = TimeInterval(self.timestamp)
            self.gyromanager.startGyroUpdates(to: OperationQueue.main) { [weak self] (data, nil) in
                if let gyroData = data {
                    //print("陀螺仪---Updates---0")
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
            self.gyromanager.stopGyroUpdates()
        }
    }
    
}
