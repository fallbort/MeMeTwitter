//
//  AppDelegate.swift
//  MeMeDemo
//
//  Created by fabo on 2021/3/4.
//

import UIKit
import MeMeTwitter

//todo
//推特开发者账号下的数据
let twitterConsumerKey = "**********"
let twitterConsumerSecret = "****************************************"


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let controller = MainViewController()
//        let nav = UINavigationController.init(rootViewController: controller)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        //todo
        //callbackUrlStr为推特开发者账号下注册的回调需要替换,开发者账号下注册的回调需要带上://，这里不用带上://
        MeMeTwitter.shared.start(withConsumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret, callbackUrlStr: "twitterkit-\(twitterConsumerKey)")
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        switch scheme {
        case "twitterkit-\(twitterConsumerKey)", "twitterkit-\(twitterConsumerKey)".lowercased():
            return MeMeTwitter.shared.application(app, open: url, options: options)
        default:
            return true
        }
    }

}

