//
//  Metronome.swift
//  PracticePal
//
//  Created by Kendall Carter on 5/12/23.
//

import Foundation
import AVFoundation

class MetronomeModel: ObservableObject {
    @Published var currentProgressWithinBar: Double = 0
//    @Published var isAccented: Bool = false

    private let audioNode: AVAudioPlayerNode
    private let audioFileMainClick: AVAudioFile
    private let audioFileAccentedClick: AVAudioFile
    private let audioEngine: AVAudioEngine

    
    private lazy var displayLink: CADisplayLink = {
        
        let displayLink = CADisplayLink(target: self, selector: #selector(updateCurrentTime))
        displayLink.add(to: .current, forMode: .default)
        return displayLink
        
    }()

    private var currentBuffer: AVAudioPCMBuffer?

    init (mainClickFile: URL, accentedClickFile: URL? = nil) {
        
        audioFileMainClick = try! AVAudioFile(forReading: mainClickFile)
        
        audioFileAccentedClick = try! AVAudioFile(forReading: accentedClickFile ?? mainClickFile)
        
        audioNode = AVAudioPlayerNode()
        
        audioEngine = AVAudioEngine()
        audioEngine.attach(self.audioNode)
        
        audioEngine.connect(audioNode, to: audioEngine.mainMixerNode, format: audioFileMainClick.processingFormat)
        try! audioEngine.start()
        
    }

    func stop() {
        
        audioNode.stop()
        displayLink.isPaused = true
        currentProgressWithinBar = 0
    }

    var isPlaying: Bool {audioNode.isPlaying}
//    var isPlaying: Bool {
//        audioNode.isPlaying
//    }

    func play(bpm: Double) {
        let buffer = genBuffer(bpm: bpm)

        currentBuffer = buffer

        if audioNode.isPlaying {
            audioNode.stop()
        }

        displayLink.isPaused = false
        audioNode.play()

        audioNode.scheduleBuffer(
            buffer,
            at: nil,
            options: [.interruptsAtLoop, .loops]
        )
    }

    @objc private func updateCurrentTime() {
        guard let nodeTime = audioNode.lastRenderTime,
              let playTime = audioNode.playerTime(forNodeTime: nodeTime),
              let buffer = currentBuffer else {
            currentProgressWithinBar = 0
            return
        }
        currentProgressWithinBar = Double(playTime.sampleTime)
            .truncatingRemainder(dividingBy: Double(buffer.frameLength))
        / Double(buffer.frameLength)
    }
    
    //isaccented
    
    
    private func genBuffer(bpm: Double) -> AVAudioPCMBuffer {
        audioFileMainClick.framePosition = 0
        audioFileAccentedClick.framePosition = 0
        
        let beatLength = AVAudioFrameCount(audioFileMainClick.processingFormat.sampleRate * 60 / bpm)
        let bufferMainClick = AVAudioPCMBuffer(pcmFormat: audioFileMainClick.processingFormat,
                                               frameCapacity: beatLength)!
        try! audioFileMainClick.read(into: bufferMainClick)
        bufferMainClick.frameLength = beatLength
        let bufferAccentedClick = AVAudioPCMBuffer(pcmFormat: audioFileMainClick.processingFormat,
                                                   frameCapacity: beatLength)!
        try! audioFileAccentedClick.read(into: bufferAccentedClick)
        bufferAccentedClick.frameLength = beatLength
        
        let bufferBar = AVAudioPCMBuffer(pcmFormat: audioFileMainClick.processingFormat,
                                         frameCapacity: 4 * beatLength)!
        bufferBar.frameLength = 4 * beatLength
        
        let channelCount = Int(audioFileMainClick.processingFormat.channelCount)
        let accentedClickArray = Array(
            UnsafeBufferPointer(start: bufferAccentedClick.floatChannelData![0],
                                count: channelCount * Int(beatLength))
        )
        let mainClickArray = Array(
            UnsafeBufferPointer(start: bufferMainClick.floatChannelData![0],
                                count: channelCount * Int(beatLength))
        )
        
        var barArray = [Float]()
        
        // first beat
        barArray.append(contentsOf: accentedClickArray)
        
        // add more here for other time signitures
        
        for _ in 1...3 {
            barArray.append(contentsOf: mainClickArray)
        }
        bufferBar.floatChannelData!.pointee.assign(from: barArray,
                                                   count: channelCount * Int(bufferBar.frameLength))
        return bufferBar
    }
}
