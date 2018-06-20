//
// Post.swift
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

import WidgetKit

extension Post {
    
    func timeAgoString(from date: Date) -> String {
        let interval = date.timeIntervalSinceNow
        let intervalInt = Int(interval) * -1
        let days = (intervalInt / 3600) / 24
        if days != 0 {
            let daysStr = String(days) + NSLocalizedString("d", comment: "Shortest abbreviation of a day.")
            return daysStr
        }
        let hours = (intervalInt / 3600)
        if hours != 0 {
            return String(hours) + NSLocalizedString("h", comment: "Shortest abbreviation of an hour.")
        }
        let minutes = (intervalInt / 60) % 60
        if minutes != 0 {
            return String(minutes) + NSLocalizedString("m", comment: "Shortest abbreviation of a minute.")
        }
        let seconds = intervalInt % 60
        if seconds != 0 {
            return String(seconds) + NSLocalizedString("s", comment: "Shortest abbreviation of a second.")
        } else {
            return NSLocalizedString("Now", comment: "Just happened. Less than a second ago.")
        }
    }
    /*
     Place you data presentation logic in your model extensions. In this case you can refer to these properties in bindings.
     */
    @objc var timeAgoString: String? {
        return timeAgoString(from: timestamp!)
    }
}

extension Post {
    
    static func show(_ posts: [Post]?) {
        posts?.forEach { post in
            post.isHidden = false
        }
    }
    
    static func showAll() {
        show(Post.objects(with: NSPredicate(format: "\(#selector(getter: Post.isHidden)) = 1")))
    }
}
