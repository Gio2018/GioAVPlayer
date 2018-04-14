//
//  AppDelegate.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/10/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import AVFoundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mediaManager: GRMediaManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        GRMediaManager.shared.fetchMedia()
        
        return true
    }
}

