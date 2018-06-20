//
// TweetsViewController.swift
//
// WidgetKit Samples, Copyright (c) Favio Mobile (http://favio.mobi)
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

import UIKit
import WidgetKit

class TweetsViewController: StandardViewController {
    
    @IBAction func newsTap(_ sender: Any?) {
        if tableView!.visibleCells.count > 0 {
            tableView!.scrollToRow(at: IndexPath.first, at: .top, animated: true)
        }
        after(0.8) { // we should wait for scrolling animation completion
            Post.showAll()
        }
    }
}

/*
 Uncomment this to see how things work.
 Do not use these methods for anything except debugging.
 */

extension TweetsViewController: SchemeDiagnosticsProtocol {

//    func created(object: NSObject, identifier: String) {
//        print(identifier)
//    }
//
//    func outlet(_ object: NSObject, addedTo: NSObject, propertyKey: String, outletKey: String) {
//        print((addedTo.gx.identifier ?? "<unknown>") + "." + propertyKey + " = " + outletKey)
//    }
//
//    func binded(_ bindings: [NSObject], in container: NSObject) {
//        print("\(container.gx.identifier ?? "<unknown>") bindings: \(bindings.count)")
//    }
//
//    func assigned(to target: NSObject, with identifier: String?, keyPath: String, source: NSObject, value: Any?, valueType: String, binding: NSObject) {
//        print("\(identifier ?? "<unknown>").\(keyPath) = \(value ?? "nil")")
//    }
//
//    func beforeAction(_ action: String, content: Any?, sender: ActionController) {
//        print("Before \(action), content = \(String(describing: content))")
//    }
//
//    func afterAction(_ action: String, result: Any?, error: Error?, sender: ActionStatusController) {
//        print("After \(action), result = \(String(describing: result)), error = \(String(describing: error))")
//    }
}
