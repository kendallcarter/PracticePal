//
//  TunerView.swift
//  PracticePal
//
//  Created by Kendall Carter on 5/12/23.
//

import Foundation
import SwiftUI
import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

let numberOfSamples: Int = 1

struct TunerView: View {
    @StateObject var tuner = Tuner()
    @State var levelRead = 0
    @State var numberOfTaps = 0
    
    @ObservedObject private var mic = Sampler(numberOfSamples: numberOfSamples)
    var body: some View {
        ZStack {

            ForEach(0..<180, id: \.self) {i in
                ForEach(mic.soundSamples, id: \.self) { level in
                    VisualizerView(val: self.normalizeSoundLevel(level: level)).offset(y:150)
                        .rotationEffect(.degrees((2*Double(i))))
                }
            }
            VStack(alignment: .center) {
                
                        VStack {

                            Text("Frequency").font(.footnote).foregroundColor(.white)
                            Text("\(tuner.data.pitch, specifier: "%0.1f")")
                        }.padding().foregroundColor(.white)

                HStack(alignment: .center) {

                    Text("\(tuner.data.noteNameWithSharps) / \(tuner.data.noteNameWithFlats)").fontWeight(.heavy).font(.largeTitle).foregroundColor(.white)
                }.padding()
                         

                    }
                    .onAppear {
                        tuner.start()
                    }
                    .onDisappear {
                        tuner.stop()
                }
        }.ignoresSafeArea(.all)
        
    }
    func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2
        return CGFloat(level)
    }

    @ViewBuilder
    func lineBasedOn(division: CGFloat) -> some View {
        
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(4 > 2 ? .green : .blue)
            .frame(width: .infinity, height: 10)
            .animation(.easeOut, value: 4/2)
            .onTapGesture {
                //                self.foregroundColor(.red)
                numberOfTaps += 1
                
            }
    }
    
    struct TunerView_Previews: PreviewProvider {
        static var previews: some View {
            TunerView()
        }
    }
}
