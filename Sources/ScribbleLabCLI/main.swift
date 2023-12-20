//
//  main.swift
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

import ArgumentParser
import Foundation

// ##################################################
//  This needs to be changed prior to every release!
// ##################################################
let cli_version = "0.0.1-dev.1 (Pre-Build)"

struct ScribbleLabCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scribblelab-cli",
        abstract: """
        A set of command line tools that ship with ScribbleLab
        which allow users to open and interact with editor via the command line.
        
        Version: \(cli_version)
        
        Copyright (c) 2023 - 2024 ScribbleLabApp.
        """,
        subcommands: [Open.self, Version.self],
        defaultSubcommand: Open.self
    )
    
    init() {}
    
    enum CLIError: Error {
        case invalidWokingDirectory
        case invalidFileURL
    }
}

ScribbleLabCLI.main()
