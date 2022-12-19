//
//  ContentView.swift
//  fillBuffer6
//
//  Created by pro on 19/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    let comment =
    """
    In FillBuffer.swift:

    //assigning individual elements takes too long
    func example1()->CVPixelBuffer {
    ...
    buf[i] = UInt8.random(in: 0...255)
    ...
    }

    //assigning the whole array at once fails
    func example2()->CVPixelBuffer {
    ...
    CVPixelBufferCreateWithBytes(...&array...)
    ...
    }

    TAP HERE TO START FILLING BUFFER,
    path to resulting movie printed in the console
    """
    
    var body: some View {
            
        Text(comment)
            .onTapGesture {
            fillBuffer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
import AVFoundation
