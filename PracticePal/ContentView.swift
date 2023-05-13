//
//  ContentView.swift
//  PracticePal
//
//  Created by Kendall Carter on 5/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    @State private var isMet: Bool = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black,.blue], startPoint: .bottomLeading, endPoint: .topTrailing)
           
            ZStack{
                HStack {
                    Spacer()
                    VStack(alignment: .leading){
                        
                        Button{
                            withAnimation(.default){
                                updateButton()
                            }
                            
                        }label: {
                            ZStack(alignment: .top) {
                                Image(systemName: "chevron.right")
                                    .labelStyle(.iconOnly)
                                    .imageScale(.large)
                                    .rotationEffect(.degrees(isMet ? 180 : 360))
                                    .animation(nil, value: isMet)
                                    
                                    .padding()
                                
                                    .opacity(isMet ? 0 : 1)
                                Image(systemName: "chevron.left")
                                    .labelStyle(.iconOnly)
                                    .imageScale(.large)
                                    .rotationEffect(.degrees(isMet ? 360 : 180))
                                    .animation(nil, value: isMet)
                                    
                                    .padding()
                                
                                    .opacity(isMet ? 1 : 0)
                            }.zIndex(1)
                                
                        }
                    }
                }.zIndex(1).offset(x:isMet ? -350 : 0)
                ZStack {
                    TabView(selection: $selection){
                                TunerView()
                                    .tag(1)
                                    .onDisappear{
                                        if(!isMet){
                                            isMet.toggle()
                                        }
                                    }
                                MetronomeView()
                                    .tag(2)
                                    .onDisappear{
                                        if(isMet){
                                            isMet.toggle()
                                        }
                                    }
                                
                            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                            .font(.title)
                }
                Spacer()
                Spacer()
                
            }
        }.ignoresSafeArea(.all)
        
    }
    
    func updateButton(){
        if(selection == 1){
            selection = 2
            //isMet.toggle()
        } else{
            selection = 1
            //isMet.toggle()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
