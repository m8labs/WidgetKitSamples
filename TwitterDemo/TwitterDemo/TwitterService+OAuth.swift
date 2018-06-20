//
// TwitterService+OAuth.swift
//
// WidgetKit Samples, Copyright (c) 2018 Favio Mobile (http://favio.mobi)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CoreData
import WidgetKit

class TwitterConfiguration: StandardServiceConfiguration {
    
    var consumerKey: String {
        preconditionFailure("Get your own ConsumerKey at https://apps.twitter.com")
//        return "C9H5Ir5RDEvK6ppLiObZCmUuz"
    }
    
    var consumerSecret: String {
        preconditionFailure("Get your own ConsumerSecret at https://apps.twitter.com")
//        return "1jQ72rq6xds HxVWPVsO82O3nVP SXGtIIAuNBIOxm 5dxaM2dEQo" // remove spaces
    }
    
    var requestTokenPath : String { return authParameters["requestTokenPath"] as! String }
    var accessTokenPath  : String { return authParameters["accessTokenPath"]  as! String }
    var callbackUrl      : String { return authParameters["callbackUrl"]      as! String }
}

/*
 This is how you can integrate custom authentication process to WidgetKit. You can use any library for this purpose.
 See BDBOAuth1SessionManager documentation for details on what's going on here.
 */

extension TwitterService {
    /*
     These actions are resolved automatically in ActionController by constructing selectors from strings, f.e 'logout' will be resolved to logout(_:sender:).
     Parameter 'content' here is taken from 'content' property of ActionController (from which methods below called). But in these two cases 'content' doesn't matter.
     If selector not found, TwitterService.performAction(action, with: content, from: sender) will be called instead.
     */
    @objc func login(_ content: Any?, sender: Any?) {
        TwitterService.oAuth.deauthorize()
        TwitterAction.login.notification.onStart.post()
        TwitterService.oAuth.fetchRequestToken(withPath: config.requestTokenPath,
                                               method: "GET", callbackURL: try! config.callbackUrl.asURL(), scope: nil, success: { requestToken in
            guard let token = requestToken?.token else { print("Empty token!"); return }
            let url = self.config.authUrl!.replacingOccurrences(of: "$token", with: token)
            UIApplication.shared.open(try! url.asURL(), options: [:], completionHandler: nil)
        }, failure: { error in
            debugPrint(error ?? "Not an error!")
            TwitterAction.login.notification.onError.post(error: error)
        })
    }
    
    @objc func logout(_ content: Any?, sender: Any?) {
        TwitterService.oAuth.deauthorize()
        persistentContainer.clear()
        TwitterAction.currentUser.notification.onError.post() // TODO: Auth window shoud be shown on this notification.
    }
}

extension TwitterService {
    
    var config: TwitterConfiguration { return configuration as! TwitterConfiguration }
    
    static var oAuth: BDBOAuth1SessionManager! = {
        return BDBOAuth1SessionManager(baseURL: try! client.config.baseUrl!.asURL(), consumerKey: client.config.consumerKey, consumerSecret: client.config.consumerSecret)
    }()
    
    func handleOpenUrl(url: URL) {
        let token = BDBOAuth1Credential(queryString: url.query)
        TwitterService.oAuth.fetchAccessToken(withPath: config.accessTokenPath, method: "POST", requestToken: token, success: { accessToken in
            debugPrint("Access token received: \(accessToken!)")
            TwitterAction.login.notification.onSuccess.post()
        }, failure: { error in
            debugPrint(error ?? "Not an error!")
            TwitterAction.login.notification.onError.post(error: error)
        })
    }
}
