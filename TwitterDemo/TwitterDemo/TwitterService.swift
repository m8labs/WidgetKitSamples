//
// TwitterService.swift
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

import Groot
import Alamofire
import WidgetKit

/*
 Basically, this is all your network stack (not including custom authentication and Service.json).
 No more tons of small files, or single huge.
 */

enum TwitterAction: Notification.Name {
    
    case login, currentUser, homeTweets
    
    var name: String { return notification.rawValue }
    var notification: Notification.Name { return rawValue }
    /*
     Shortcut method for calling network actions.
     */
    func perform(with object: Any? = nil, sender: Any? = nil, completion: Completion? = nil) {
        TwitterService.client.performAction(name, with: object, from: sender, completion: completion)
    }
}

class TwitterService: StandardServiceProvider {
    
    static let errorDomain = "TwitterServiceError"
    
    static var client = TwitterService()
    
    override func setup() {
        configuration = TwitterConfiguration(bundle: nil)
        /*
         This is how you can integrate custom auth process to WidgetKit. You can use any library for your authentication.
         All you need to do is to construct URLRequest in this closure.
         */
        configuration.setRequestComposer { action, method, url, body, headers in
            if self.configuration.needAuth(for: action) {
                let request = TwitterService.oAuth.requestSerializer.request(withMethod: method.rawValue, urlString: url, parameters: body, error: nil)
                return request as URLRequest
            }
            return nil
        }
        printFullResponse = false
    }
    /*
     Override to handle errors from your service. You must return either Error or nil.
     Do not show error messages here to the user, there is another place for this - view controller's handleError(_:sender:) method (which shows alert by default).
     */
    override func serverError(for action: String, code: Int, data: Data?) -> Error? {
        guard code != 200 else { return nil }
        switch code {
        case 404:
            return NSError(domain: TwitterService.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: "404: Action not found."])
        case 429:
            return NSError(domain: TwitterService.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: "Too many requests!"])
        default:
            if let json = data?.jsonObject() as? JSONDictionary {
                if let message = json["error"] as? String {
                    return NSError(domain: TwitterService.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
                } else if let errors = json["errors"] as? [JSONDictionary] {
                    let combinedMessage = NSLocalizedString("Server errors:\n", comment: "") + errors.map({ $0["message"] as! String }).joined(separator: "\n")
                    return NSError(domain: TwitterService.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: combinedMessage])
                }
            }
        }
        return NSError(domain: TwitterService.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
    }
}

/*
 Uncomment this to see how things work.
 Do not use these methods for anything except debugging.
 */
extension TwitterService {

//    override func before(action: String, request: URLRequest) {
//        super.before(action: action, request: request)
//    }
//
//    override func after(action: String, request: URLRequest?, response: URLResponse?, data: Data?) {
//        super.after(action: action, request: request, response: response, data: data)
//    }
}
