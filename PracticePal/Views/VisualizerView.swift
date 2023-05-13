//
//  VisualizerView.swift
//  PracticePal
//
//  Created by Kendall Carter on 5/12/23.
//

import SwiftUI

struct VisualizerView: View {
    let numberOfSamples: Int = 12
    let val: CGFloat
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [.blue,.green]), startPoint: .top, endPoint: .bottom))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: val*1.5)
        }
    }
}


