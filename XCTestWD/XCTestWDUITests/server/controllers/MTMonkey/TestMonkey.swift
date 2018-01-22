//
//  TestMonkey.swift
//  XCTestWDUITests
//
//  Created by 李梦 on 2018/1/18.
//  Copyright © 2018年 XCTestWD. All rights reserved.
//

import Foundation

class TestMonkey {
    
    static func generalMode(_ application: XCUIApplication) {
        _ = application.descendants(matching: .any).element(boundBy: 0).frame
        let monkey = Monkey(frame: application.frame, bundleid: application.bundleID)
        monkey.addDefaultXCTestPrivateActions()
        monkey.addXCTestTapAlertAction(interval: 100, application: application)
//        monkey.addXCTestActivateAppAction(interval: 10, application: application)
        monkey.monkeyAround()
    }
    
}
