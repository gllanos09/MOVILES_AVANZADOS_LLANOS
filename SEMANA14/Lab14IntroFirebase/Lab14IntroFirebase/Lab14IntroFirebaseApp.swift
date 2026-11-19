//
//  Lab14IntroFirebaseApp.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 19/11/26.
//

import SwiftUI
import FirebaseCore

@main
struct Lab14IntroFirebaseApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
