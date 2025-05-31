//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Guest Account on 5/30/25.
//

import SwiftUI
import FirebaseCore

@main
struct ToDoListApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
