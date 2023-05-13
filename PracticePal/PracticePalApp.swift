//
//  PracticePalApp.swift
//  PracticePal
//
//  Created by Kendall Carter on 5/12/23.
//

import SwiftUI
import AVFoundation
import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit

@main
struct PracticePalApp: App {
    init() {
        #if os(iOS)
            do {
                Settings.bufferLength = .short
                try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                                options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let err {
                print(err)
            }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.colorScheme, .dark)
        }
    }
}
