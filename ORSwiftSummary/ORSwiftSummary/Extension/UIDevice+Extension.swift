//
//  UIDevice+Extension.swift
//  UAgent
//
//  Created by TY on 2019/3/17.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import UIKit

extension UIDevice{
    static func ISIPHONE_X()->Bool{
        if UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896 {
            return true
        }
        return false
    }
    
    static func isSmallPhone()->Bool{
        if UIScreen.main.bounds.height <= 568 {
            return true
        }
        return false
    }

    static func getUserUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func isSimulator()->(Bool){
          #if arch(i386) || arch(x86_64)
              return true
          #else
              return false
          #endif
      }
    
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone7Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone8"
        case "iPhone10,2":                              return "iPhone8Plus"
        case "iPhone10,3":                              return "iPhoneX"
        case "iPhone10,5":                              return "iPhone8Plus"
        case "iPhone10,6":                              return "iPhoneX"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    public enum DeviceType{
        case unknown
        case iPodTouch_5
        case iPodTouch_6
        case iPhone_4
        case iPhone_4s
        case iPhone_5
        case iPhone_5c
        case iPhone_5s
        case iPhone_6
        case iPhone_6Plus
        case iPhone_6s
        case iPhone_6sPlus
        case iPhone_SE
        case iPhone_7
        case iPhone_7Plus
        case iPhone_8
        case iPhone_8Plus
        case iPhone_X
        case iPad_2
        case iPad_3
        case iPad_4
        case iPad_Air
        case iPad_Air2
        case iPad_Mini
        case iPad_Mini2
        case iPad_Mini3
        case iPad_Mini4
        case iPad_Pro
        case apple_TV
        case simulator
        
        static func type()-> DeviceType{
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            switch identifier {
            case "iPod5,1":
                return .iPodTouch_5
            case "iPod7,1":
                return .iPodTouch_6
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":
                return .iPhone_4
            case "iPhone4,1":
                return .iPhone_4s
            case "iPhone5,1", "iPhone5,2":
                return .iPhone_5
            case "iPhone5,3", "iPhone5,4":
                return .iPhone_5c
            case "iPhone6,1", "iPhone6,2":
                return .iPhone_5s
            case "iPhone7,2":
                return .iPhone_6
            case "iPhone7,1":
                return .iPhone_6Plus
            case "iPhone8,1":
                return .iPhone_6s
            case "iPhone8,2":
                return .iPhone_6sPlus
            case "iPhone8,4":
                return .iPhone_SE
            case "iPhone9,1", "iPhone9,3":
                return .iPhone_7
            case "iPhone9,2", "iPhone9,4":
                return .iPhone_7Plus
            case "iPhone10,1":
                return .iPhone_8
            case "iPhone10,2":
                return .iPhone_8Plus
            case "iPhone10,3":
                return .iPhone_X
            case "iPhone10,4":
                return .iPhone_8
            case "iPhone10,5":
                return .iPhone_8Plus
            case "iPhone10,6":
                return .iPhone_X
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
                return .iPad_2
            case "iPad3,1", "iPad3,2", "iPad3,3":
                return .iPad_3
            case "iPad3,4", "iPad3,5", "iPad3,6":
                return .iPad_4
            case "iPad4,1", "iPad4,2", "iPad4,3":
                return .iPad_Air
            case "iPad5,3", "iPad5,4":
                return .iPad_Air2
            case "iPad2,5", "iPad2,6", "iPad2,7":
                return .iPad_Mini
            case "iPad4,4", "iPad4,5", "iPad4,6":
                return .iPad_Mini2
            case "iPad4,7", "iPad4,8", "iPad4,9":
                return .iPad_Mini3
            case "iPad5,1", "iPad5,2":
                return .iPad_Mini4
            case "iPad6,7", "iPad6,8":
                return .iPad_Pro
            case "AppleTV5,3":
                return .apple_TV
            case "i386", "x86_64":
                return .simulator
            default:
                return .unknown
            }
        }
    }
    
    var type : DeviceType{
        return DeviceType.type()
    }
    
    func isDebug() -> Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
