//
//  FillBufer.swift
//  fillBuffer6
//
//  Created by pro on 19/12/2022.
//

import AVFoundation
func example1()->CVPixelBuffer{
    let attributes = [kCVPixelBufferCGImageCompatibilityKey:kCFBooleanTrue,
              kCVPixelBufferCGBitmapContextCompatibilityKey:kCFBooleanTrue] as CFDictionary
    var nullablePixelBuffer: CVPixelBuffer? = nil

    let status = CVPixelBufferCreate(
        kCFAllocatorDefault,
        Int(640),
        Int (480),
        kCVPixelFormatType_OneComponent8,
        attributes,
        &nullablePixelBuffer)
    
    guard status == kCVReturnSuccess, let pixelBuffer = nullablePixelBuffer else { fatalError() }
    
    let width = CVPixelBufferGetWidth (pixelBuffer)
    let height = CVPixelBufferGetHeight (pixelBuffer)
    CVPixelBufferLockBaseAddress(pixelBuffer,CVPixelBufferLockFlags (rawValue: 0))
    if let baseAddress = CVPixelBufferGetBaseAddress (pixelBuffer) {
       let buf = baseAddress.assumingMemoryBound(to: UInt8.self)
        for i in 0..<width*height{
            buf[i] = UInt8.random(in: 0...255)
        }
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer,CVPixelBufferLockFlags (rawValue: 0))
    return pixelBuffer
}

func example2()->CVPixelBuffer{
    var data:[UInt8] = Array(repeating: {UInt8.random(in: UInt8.min...UInt8.max)},count: 640*480).map{$0()}
    var nullablePixelBuffer: CVPixelBuffer? = nil

    let status = CVPixelBufferCreateWithBytes(
        kCFAllocatorDefault,
        Int(640),
        Int(480),
        kCVPixelFormatType_OneComponent8,
        &data,
        Int(640),
        nil,
        nil,
        nil,
        &nullablePixelBuffer
    )
    guard status == kCVReturnSuccess, let pixelBuffer = nullablePixelBuffer else { fatalError() }
    return pixelBuffer
}




func fillBuffer(){
    let outputMovieURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("test\(Int.random(in: 100..<1000)).mov")
    let assetwriter = try! AVAssetWriter(outputURL: outputMovieURL, fileType: .mov)
    let settingsAssistant = AVOutputSettingsAssistant(preset: .preset640x480)!.videoSettings
    let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: settingsAssistant)

    let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: settingsAssistant)
    assetwriter.add(assetWriterInput)
    assetwriter.startWriting()
    assetwriter.startSession(atSourceTime: CMTime.zero)

    let duration = 1
    let framesPerSecond = 30
    let totalFrames = duration * framesPerSecond
    var frameCount = 0
    
    while frameCount < totalFrames {
       if assetWriterInput.isReadyForMoreMediaData {
          let frameTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(framesPerSecond))
           
           let pixelBuffer = example1()
//         let pixelBuffer = example2()

           assetWriterAdaptor.append(pixelBuffer, withPresentationTime: frameTime)
           frameCount+=1
       }
    }
    
    assetWriterInput.markAsFinished()
    assetwriter.finishWriting{
    }

    print(outputMovieURL)
}
