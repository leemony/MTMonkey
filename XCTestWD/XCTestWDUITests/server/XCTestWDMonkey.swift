//
//  XCTestWDMonkey.swift
//  XCTestWDUITests
//
//  Created by 李梦 on 2018/1/18.
//  Copyright © 2018年 XCTestWD. All rights reserved.
//

import Foundation
import Swifter

public class XCTestWDMonkey {
    
    private let server = HttpServer()
    
    internal func startMonkey(bundleID: String) -> Int {
        
        var app : XCUIApplication!
        var session : XCTestWDSession!
        
        let path: String? = nil
        
        app = XCUIApplication.init(privateWithPath: path, bundleID: bundleID)!
        app!.launch()
        sleep(5)
        
        if app != nil {
            session = XCTestWDSession.sessionWithApplication(app!)
            XCTestWDSessionManager.singleton.defaultSession = session;
            XCTestWDSessionManager.singleton.mountSession(session)
            session.resolve()
        }
        
        if app?.processID == 0 {
            return -1
        }
        
        NSLog("XCTestWDSetup-> Start Monkey <-XCTestWDSetup")
        TestMonkey.generalMode(app)
        
        RunLoop.main.run()
        return 0
    }
    
    internal func stopMonkey() {
        server.stop()
    }
}
