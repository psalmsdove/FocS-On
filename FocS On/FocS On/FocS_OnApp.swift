//
//  FocS_OnApp.swift
//  FocS On
//
//  Created by Ali Erdem Kökcik on 25.09.2022.
//

import SwiftUI

@main
struct FocS_OnApp: App {
    //Mark: Since we're doing background fetching Initializing here.
    @StateObject var pomodoroModel: PomodoroModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroModel)
        }
    }
}
