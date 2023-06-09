//
//  NVCApp.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 5/21/23.
//

import SwiftUI
import AVFoundation

@main
struct NVCApp: App {
    @StateObject private var appState = AppState()
    init() {
        setupAudioSession()
    }
    var body: some Scene {
        WindowGroup {
            SplashScreen().environmentObject(appState)
        }
        WindowGroup {
            RephraseView().environmentObject(appState)
        }
    }
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed: \(error)")
        }
    }
}
