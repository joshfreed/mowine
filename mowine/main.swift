//
//  main.swift
//  mowine
//
//  Created by Josh Freed on 11/13/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClassName = isRunningTests ? nil : NSStringFromClass(AppDelegate.self)
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClassName)
