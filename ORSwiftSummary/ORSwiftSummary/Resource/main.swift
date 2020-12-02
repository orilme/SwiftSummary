//
//  main.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/11/26.
//  Copyright © 2019 orilme. All rights reserved.
//

import UIKit

var appStartLaunchTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()

UIApplicationMain(CommandLine.argc, UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self,capacity: Int(CommandLine.argc)), nil, NSStringFromClass(AppDelegate.self))
