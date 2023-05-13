//
//  MetronomeView.swift
//  PracticePal
//
//  Created by Kendall Carter on 5/12/23.
//

import SwiftUI

struct MetronomeView: View {
    @ObservedObject var metronome: MetronomeModel

    init() {
        metronome = MetronomeModel(
            mainClickFile: Bundle.main.url(
                forResource: "Low", withExtension: "wav"
            )!,
            accentedClickFile: Bundle.main.url(
                forResource: "High", withExtension: "wav"
            )!
        )
    }

    @State var tempo = 120
    @State var numberOfTaps = 0
    @State private var showDetail = false
    @State private var isPlaying = false


    var body: some View {
        ZStack {
//            LinearGradient(colors: [.black,.blue], startPoint: .bottomTrailing, endPoint: .topLeading)
            VStack(spacing: 12) {
                

                HStack{
                    Picker("", selection: $tempo){
                        ForEach(10..<300){
                            Text("\(($0)-10) ")
                        }
                    }.fontWeight(.heavy).onChange(of: tempo, perform: { newValue in
                        if metronome.isPlaying {
                            metronome.play(bpm: Double(newValue))
                        }
                    })
                    Stepper("", value: $tempo, in: 10...300).foregroundColor(.white)
                        .onChange(of: tempo, perform: { newValue in
                            if metronome.isPlaying {
                                metronome.play(bpm: Double(newValue))
                            }
                        })
                        .frame(maxWidth: 100)
                }

                Button {
                    
                    (
                        metronome.isPlaying ? metronome.stop() : metronome.play(bpm: Double(tempo))
                    )
                                } label: {
                                    ZStack{
                                        Label("Play/Pause Met", systemImage: "play.circle")
                                            .foregroundColor(.blue)
                                            .labelStyle(.iconOnly)
                                            .imageScale(.large)
                
                                            .animation(nil, value: metronome.isPlaying)
                                            .scaleEffect(metronome.isPlaying ? 1.5 : 1)
                                            .padding()
                                            .animation(.spring(), value: metronome.isPlaying)
                                            .opacity(metronome.isPlaying ? 0 : 1)
                                        Label("Play/Pause Met", systemImage: "pause.circle")
                                            .foregroundColor(.green)
                                            .labelStyle(.iconOnly)
                                            .imageScale(.large)
                                            
                                            .animation(nil, value: metronome.isPlaying)
                                            .scaleEffect(metronome.isPlaying ? 1.5 : 1)
                                            .padding()
                                            .animation(.spring(), value: metronome.isPlaying)
                                            .opacity(metronome.isPlaying ? 1 : 0)
                                    }.scaleEffect(1.5)
                                }
                HStack {
                    drawLine(division: 0)
                    drawLine(division: 0.25)
                    drawLine(division: 0.5)
                    drawLine(division: 0.75)
                }
                .frame(height: 20)
                
                
            }
            .padding()
            
        }.ignoresSafeArea(.all)
        
    }
    
    @ViewBuilder
    private func drawLine(division: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(metronome.currentProgressWithinBar > division ? .green : .blue)
            .frame(width: .infinity, height: 10)
            .animation(.easeOut, value: metronome.currentProgressWithinBar/2)
            .onTapGesture {
//                self.foregroundColor(.red)
                numberOfTaps += 1
                
            }
    }
}
extension Animation{
    static func ripple() -> Animation {
        Animation.spring(dampingFraction:0.5)
            .speed(2)

    }
}

struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView()
    }
}
