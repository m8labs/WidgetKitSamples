//
// SettingsViewController.swift
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

import UIKit

/*
 This view controller is not data-driven. This *is* the reason why it contains code.
 */

extension Notification.Name {
    public static let showAvatarsChanged = Notification.Name("showAvatarsChanged")
}

class SettingsViewController: UITableViewController {
    
    static var showAvatars = "showAvatars"
    
    @IBOutlet var showAvatarsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isOn = UserDefaults.standard.bool(forKey: SettingsViewController.showAvatars)
        self.showAvatarsSwitch.isOn = isOn
    }
    
    @IBAction func showAvatarsChanged(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: SettingsViewController.showAvatars)
    }
    
    @IBAction func done(sender: UIControl) {
        dismiss(animated: true) {
            Notification.Name.showAvatarsChanged.post()
        }
    }
}
