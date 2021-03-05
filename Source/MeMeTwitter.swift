//
//  MeMeTwitter.swift
//
//
//  Created by fabo on 2021/3/4.
//  Copyright © 2021 . All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices

public class MeMeTwitterShareData {
    public var url:URL?
    public var text:String?
    public var image:UIImage?
    
    public init() {
        
    }
}

public enum MeMeTwitterShareStage {
    case check
    case login
    case beforeShare
    case end
}

public class MeMeTwitter : NSObject {
    public static var shared:MeMeTwitter = MeMeTwitter()
    //MARK:<>外部变量
    
    //MARK:<>外部block
    
    //MARK:<>生命周期开始
    
    //MARK:<>功能性方法
    public func start(withConsumerKey: String, consumerSecret: String,callbackUrlStr:String) {
        swifter = Swifter(consumerKey: withConsumerKey, consumerSecret: consumerSecret, appOnly: false)
        self.callbackUrlStr = callbackUrlStr
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [AnyHashable : Any] = [:]) -> Bool {
        if Self.twitterAppInstalled() {
            Swifter.handleOpenURL(url,callbackURL: URL.init(string: callbackUrlStr)!, isSSO: true)
        } else {
            Swifter.handleOpenURL(url,callbackURL: URL.init(string: callbackUrlStr)!)
        }
        return true
    }
    
    public func logIn(with: UIViewController?,complete:((_ :Credential.OAuthAccessToken?,_ :Error?)->())? = nil) {
        if Self.twitterAppInstalled() {
            authorizeWithSSO(with:with,complete: complete)
        } else {
            authorizeWithWebLogin(with:with,complete: complete)
        }
    }
    
    public func hasLogined() -> Bool {
        if swifter?.client.credential?.accessToken?.key != nil {
            return true
        }
        return false
    }
    
    public func share(with: UIViewController? = nil,data:MeMeTwitterShareData,complete:((_ stage:MeMeTwitterShareStage,_ ret:Bool)->())? = nil) {
        complete?(.check,true)
        if hasLogined() {
            complete?(.beforeShare,true)
            realShare(data, complete: complete)
        }else{
            complete?(.login,true)
            logIn(with: with) { (info, error) in
                if error == nil {
                    complete?(.beforeShare,true)
                    self.realShare(data, complete: complete)
                }else{
                    complete?(.end,false)
                }
            }
        }
    }
    
    fileprivate func realShare(_ shareData:MeMeTwitterShareData,complete:((_ stage:MeMeTwitterShareStage,_ ret:Bool)->())? = nil) {
        let text = (shareData.text?.count ?? 0) > 0 ? "\(shareData.text ?? "")" : ""
        let urlStr = shareData.url?.absoluteString
        let url = (urlStr?.count ?? 0) > 0 ? "\(urlStr ?? "")" : ""
        let status = (url.count > 0 && text.count > 0) ? "\(text)\n\(url)" : text + url
        if let swifter = swifter {
            if let image = shareData.image,let pngData = image.pngData() {
                swifter.postTweet(status: status, media: pngData, success: { (json) in
                    complete?(.end,true)
                }, failure: { (error) in
                    complete?(.end,false)
                })
            }else {
                swifter.postTweet(status: status) { (json) in
                    complete?(.end,true)
                } failure: { (error) in
                    complete?(.end,false)
                }

            }
            
        }else{
            complete?(.end,false)
        }
    }
    
    private func authorizeWithWebLogin(with: UIViewController?,complete:((_ :Credential.OAuthAccessToken?,_ :Error?)->())?) {
        let callbackUrl = URL(string: callbackUrlStr)!

        if let swifter = swifter {
            if #available(iOS 13.0, *) {
                swifter.authorize(withProvider: self, callbackURL: callbackUrl) { (token, response) in
                    complete?(token,nil)
                } failure: { (error) in
                    complete?(nil,error)
                }
            } else {
                swifter.authorize(withCallback: callbackUrl, presentingFrom: with) { (token, response) in
                    complete?(token,nil)
                } failure: { (error) in
                    complete?(nil,error)
                }
            }
        }else{
            complete?(nil,NSError.init(domain: "", code: 999, userInfo: nil))
        }
        
    }

    private func authorizeWithSSO(with: UIViewController?,complete:((_ :Credential.OAuthAccessToken?,_ :Error?)->())?) {
        let callbackUrl = URL(string: callbackUrlStr)!
        if let swifter = swifter {
            swifter.authorizeSSO(callbackURL: callbackUrl) { (token) in
                complete?(token,nil)
            } failure: { (error) in
                complete?(nil,error)
            }
        }else {
            complete?(nil,NSError.init(domain: "", code: 999, userInfo: nil))
        }
    }
    
    public class func twitterAppInstalled() -> Bool {
        if let url = URL(string: "twitter://") {
            return UIApplication.shared.canOpenURL(url)
        } else {
            return false
        }
    }
    
    //MARK:<>内部View
    //MARK:<>内部UI变量
    //MARK:<>内部数据变量
    private var swifter:Swifter?
    private var callbackUrlStr:String = ""
    //MARK:<>内部block
}

// This is need for ASWebAuthenticationSession
@available(iOS 13.0, *)
extension MeMeTwitter: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
}
