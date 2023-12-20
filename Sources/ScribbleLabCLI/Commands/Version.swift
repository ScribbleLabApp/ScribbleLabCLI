//
//  Version.swift
//  ScribbleLab CLI
//
//  Copyright (c) 2023 - 2024 ScribbleLabApp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AppKit
import ArgumentParser
import Foundation

extension ScribbleLabCLI {
    struct Version: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "version",
            abstract: "Prints the version of the CLI and ScribbleLab.app."
        )
        
        @Flag(name: .shortAndLong, help: "Only prints the version number of the CLI")
        var terse = false
        
        func run() throws {
            // if terse flag is set only print the cli version number
            if terse {
                print(cli_version)
                return
            }
            
            // Print the cli version
            print("ScribbleLab CLI: \t\(cli_version)")
            
            // File URL of ScribbleLab.app
            let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.nhstudio.ScribbleLab") // app.nhstudio.ScribbleLab
            
            // Check if there is an Info.plist inside ScribbleLab.app
            // Then get the version number and print it out
            //
            // This will fail when ScribbleLab.app is not installed
            if let url = infoPlistUrl(appURL),
               let plist = NSDictionary(contentsOf: url) as? [String: Any],
               let version = plist["CFBundleShortVersionString"] as? String {
                print("ScribbleLab.app: \t\(version)")
            } else {
                print("ScribbleLab.app is not installed.")
            }
        }
        
        private func infoPlistUrl(_ url: URL?) -> URL? {
            if let url = url?.appendingPathComponent("Contents")
                             .appendingPathComponent("Info.plist") {
                return url
            } else {
                return nil
            }
        }
    }
}
