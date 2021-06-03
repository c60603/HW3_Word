//
//  HW3_WordApp.swift
//  HW3_Word
//
//  Created by User08 on 2021/5/12.
//

import SwiftUI

@main
struct HW3_WordApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            PageSwitch()
        }
    }
}
