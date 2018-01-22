//
//  XCTestWDMonkeyController.swift
//  XCTestWDUITests
//
//  Created by 李梦 on 2018/1/17.
//  Copyright © 2018年 XCTestWD. All rights reserved.
//

import Foundation
import Swifter
import SwiftyJSON

internal class XCTestWDMonkeyController: Controller {

    //MARK: Controller - Protocol
    static func routes() -> [(RequestRoute, RoutingCall)] {
        return [(RequestRoute("/wd/hub/session/:sessionId/monkey", "post"), swiftMonkey)]
//        return [(RequestRoute("/wd/hub/monkey", "post"), swiftMonkey)]
    }
    
    static func shouldRegisterAutomatically() -> Bool {
        return false
    }
    
    //MARK: Routing Logic Specification
    internal static func getAppName(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        return HttpResponse.ok(.html("name"))
    }
    
    internal static func swiftMonkey(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
//        var app : XCUIApplication!
//        var session : XCTestWDSession!
//
//        let desiredCapabilities = request.jsonBody["desiredCapabilities"].dictionary
//        let path = desiredCapabilities?["app"]?.string ?? nil
//        let bundleID = desiredCapabilities?["bundleId"]?.string ?? nil
//        if bundleID == nil {
//            app = XCTestWDSession.activeApplication()
//        } else {
//            app = XCUIApplication.init(privateWithPath: path, bundleID: bundleID)!
//            app!.launchArguments = desiredCapabilities?["arguments"]?.arrayObject as! [String]? ?? [String]()
//            app!.launchEnvironment = desiredCapabilities?["environment"]?.dictionaryObject as! [String : String]? ?? [String:String]();
//            app!.launch()
//        }
//
//        if app != nil {
//            session = XCTestWDSession.sessionWithApplication(app!)
//            XCTestWDSessionManager.singleton.mountSession(session)
//            try? session.resolve()
//        }
//
//        if app?.processID == 0 {
//            return HttpResponse.internalServerError
//        }
        
        let session = request.session ?? XCTestWDSessionManager.singleton.checkDefaultSession()
        let application = session.application
        
//        let session = XCTestWDSessionManager.singleton.checkDefaultSession()
//        let application = session.application
        
        sleep(10)
        NSLog("XCTestWDSetup-> Start Monkey <-XCTestWDSetup")

        TestMonkey.generalMode(application!)
        
        return XCTestWDResponse.response(session: session, value: nil)
    }

}
