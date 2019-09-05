//
//  AppDelegate.swift
//  iOS13VideoRecordingError
//
//  Created by Qiu Dong on 2019/9/3.
//  Copyright © 2019 Qiu Dong. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func compileAudioAndVideoToMovie(audioInputURL:URL, videoInputURL:URL) {
        let docPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let videoOutputURL:URL = URL(fileURLWithPath: docPath).appendingPathComponent("video_output.mov");
        do
        {
            try FileManager.default.removeItem(at: videoOutputURL);
        }
        catch {}
        let mixComposition = AVMutableComposition();
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid);
        let videoInputAsset = AVURLAsset(url: videoInputURL);
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid);
        let audioInputAsset = AVURLAsset(url: audioInputURL);
        do
        {
            try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTimeMake(value: 0, timescale: 1000), duration: CMTimeMake(value: 3000, timescale: 1000)), of: videoInputAsset.tracks(withMediaType: AVMediaType.video)[0], at: CMTimeMake(value: 0, timescale: 1000));// Insert an 3-second video clip into the video track
            try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTimeMake(value: 0, timescale: 1000), duration: CMTimeMake(value: 3000, timescale: 1000)), of: audioInputAsset.tracks(withMediaType: AVMediaType.audio)[0], at: CMTimeMake(value: 0, timescale: 1000));// Insert an 3-second audio clip into the audio track
            
            let assetExporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetPassthrough);
            assetExporter?.outputFileType = AVFileType.mov;
            assetExporter?.outputURL = videoOutputURL;
            assetExporter?.shouldOptimizeForNetworkUse = false;
            assetExporter?.exportAsynchronously {
                switch (assetExporter?.status)
                {
                case .cancelled:
                    print("Exporting cancelled");
                case .completed:
                    print("Exporting completed");
                case .exporting:
                    print("Exporting ...");
                case .failed:
                    print("Exporting failed");
                default:
                    print("Exporting with other result");
                }
                if let error = assetExporter?.error
                {
                    print("Error:\n\(error)");
                }
            }
        }
        catch
        {
            print("Exception when compiling movie");
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let docPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
//        let videoInputURL = URL(fileURLWithPath: docPath).appendingPathComponent("video_input.mp4");
//        let audioInputURL:URL = URL(fileURLWithPath: docPath).appendingPathComponent("audio_input.aac");
        let videoInputURL = URL(fileURLWithPath: Bundle.main.path(forResource: "video_input", ofType: "mp4")!);
        let audioInputURL = URL(fileURLWithPath: Bundle.main.path(forResource: "audio_input", ofType: "aac")!);
        compileAudioAndVideoToMovie(audioInputURL: audioInputURL, videoInputURL: videoInputURL);
//        do {
//            try videoWriter = AVAssetWriter(url: videoInputURL, fileType: AVFileType.m4v);
//
//            let videoSettings:[String:Any] = [
//                AVVideoCodecKey:AVVideoCodecType.h264,
//                AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey: NSNumber(floatLiteral: 46137388)],
//                AVVideoWidthKey: NSNumber(integerLiteral: 3840), AVVideoHeightKey: NSNumber(integerLiteral: 1920)];
//            videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings);
//            videoWriterInput?.expectsMediaDataInRealTime = true;
//            videoWriterInput?.transform = __CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
//
//            let sourcePixelBufferAttributes:[String:Any] = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
//                                               kCVPixelBufferWidthKey as String: NSNumber(integerLiteral: 3840),
//                                               kCVPixelBufferHeightKey as String: NSNumber(integerLiteral: 1920),
//                                               kCVPixelFormatOpenGLESCompatibility as String: NSNumber(booleanLiteral: CFBooleanGetValue(kCFBooleanTrue!))];
//            guard let videoWriterInput = self.videoWriterInput else { return true; }
//            guard let videoWriter = self.videoWriter else { return true; }
//            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributes);
//
//            if (videoWriter.canAdd(videoWriterInput))
//            {
//                videoWriter.add(videoWriterInput);
//                if (videoWriter.startWriting())
//                {
//                    videoWriter.startSession(atSourceTime: CMTimeMake(value: 0, timescale: 100000));
//                }
//            }
//
//            guard let pixelBufferAdaptor = self.pixelBufferAdaptor else { return true; }
//
//            let pixelBufferOutput:UnsafeMutablePointer<CVPixelBuffer?> = UnsafeMutablePointer<CVPixelBuffer?>.allocate(capacity: MemoryLayout<CVPixelBuffer?>.stride);
//            CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferAdaptor.pixelBufferPool!, pixelBufferOutput);
//            self.pixelBuffer = pixelBufferOutput.pointee;
//            guard let pixelBuffer = self.pixelBuffer else { return true; }
//
//            DispatchQueue.global().async {
//                for i in 0..<30
//                {
//                    if (pixelBufferAdaptor.assetWriterInput.isReadyForMoreMediaData)
//                    {
//                        let frameTime = CMTimeMake(value: Int64(1000 * i / 30), timescale: 1000);
//                        let appendOK = pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: frameTime);
//                        if (!appendOK || videoWriter.error != nil || videoWriter.status == AVAssetWriter.Status.failed || videoWriter.status == AVAssetWriter.Status.cancelled)
//                        {
//                            Thread.sleep(forTimeInterval: 0.1);
//                        }
//                    }
//                    else
//                    {
//                        Thread.sleep(forTimeInterval: 0.1);
//                    }
//                }
//                videoWriter.endSession(atSourceTime: CMTimeMake(value: 1000, timescale: 1000));
//                videoWriter.finishWriting {
//                    if (videoWriter.status != AVAssetWriter.Status.completed)
//                    {
//                        return;
//                    }
//                    videoWriterInput.markAsFinished();
//                    self.compileAudioAndVideoToMovie(audioInputURL: audioInputURL, videoInputURL: videoInputURL);
//                }
//            }
//        } catch {
//            print("Exception when creating videoWriter");
//        }
        
        return true
    }
    //    var pixelBuffer:CVPixelBuffer?
    //    var videoWriter:AVAssetWriter?
    //    var videoWriterInput:AVAssetWriterInput?
    //    var pixelBufferAdaptor:AVAssetWriterInputPixelBufferAdaptor?

    // MARK: UISceneSession Lifecycle
/*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
*/

}

