//
//  Tuner.swift
//  PracticePal
//
//  Created by Kendall Carter on 5/12/23.
//

import Foundation
import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit

class Tuner: ObservableObject, HasAudioEngine {
    
    @Published var data = TunerModel()

    let engine = AudioEngine()
    let initialDevice: Device

    let mic: AudioEngine.InputNode
    
    let nodeA: Fader
    let nodeB: Fader
    let nodeC: Fader
    let silence: Fader

    var picthTap: PitchTap!

    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

    
    init() {
        guard let input = engine.input else { fatalError() }

        guard let device = engine.inputDevice else { fatalError() }

        initialDevice = device
        mic = input
        
        nodeA = Fader(mic)
        nodeB = Fader(nodeA)
        nodeC = Fader(nodeB)
        silence = Fader(nodeC, gain: 0)
        
        engine.output = silence

        picthTap = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.updatePitch(pitch[0], amp[0])
            }
        }
        picthTap.start()
    }
    
    

    func updatePitch(_ pitch: AUValue, _ amp: AUValue) {
        guard amp > 0.1 else { return }

        data.pitch = pitch
        data.amplitude = amp
        var frequency = pitch
        
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
            frequency /= 2.0
        }
        
        while frequency < Float(noteFrequencies[0]) {
            frequency *= 2.0
        }

        var minDistance: Float = 10000.0
        
        
        var index = 0
        for possibleIndex in 0 ..< noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        
        let octave = Int(log2f(pitch / frequency))
        
        data.noteNameWithSharps = "\(noteNamesWithSharps[index])\(octave)"
        data.noteNameWithFlats = "\(noteNamesWithFlats[index])\(octave)"
    }
}
