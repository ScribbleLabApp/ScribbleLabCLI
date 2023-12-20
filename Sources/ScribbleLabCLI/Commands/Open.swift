//
//  Open.swift
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

extension ScribbleLabCLI {
    struct Open: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "open",
            abstract: "A command-line tool to open files/folders in ScribbleLab.app"
        )
        
        @Argument(
            help: """
            The path of a file/folder to open.
            When opening files, line and column numbers can be appended: `test.txt:42:10`
            """,
            completion: .file()
        )
        private var path: String?
        
        func run() throws {
            let task = Process()
            
            // use the `open` cli as the executable
            task.launchPath = "/usr/bin/open"
            
            if let path {
                let (path, line, column) = try extractLineColumn(path)
                let openURL = try absolutePath(path, for: task)

                // open ScribbleLab using the url scheme
                if let line, !openURL.hasDirectoryPath {
                    task.arguments = ["-u", "scribblelab://\(openURL.path):\(line):\(column ?? 1)"]
                } else {
                    task.arguments = ["-u", "scribblelab://\(openURL.path)"]
                }
            } else {
                task.arguments = ["-a", "ScribbleLab.app"]
            }

            try task.run()
        }
        
        private func absolutePath(_ path: String, for task: Process) throws -> URL {
            guard let workingDirectory = task.currentDirectoryURL,
                let url = URL(string: path, relativeTo: workingDirectory) else {
               throw CLIError.invalidWorkingDirectory
            }
            return url
        }
        
        private func extractLineColumn(_ path: String) throws -> (path: String, line: Int?, column: Int?) {
            // split the string at `:` to get line and column numbers
            let components = path.split(separator: ":")

            // set path to only the first component
            guard let first = components.first else {
                throw CLIError.invalidFileURL
            }
            let path = String(first)

            // switch on the number of components
            switch components.count {
            case 1: // no line or column number provided
                return (path, nil, nil)

            case 2: // only line number provided
                guard let row = Int(components[1]) else { throw CLIError.invalidFileURL }
                return (path, row, nil)

            case 3: // line and column number provided
                guard let row = Int(components[1]),
                let column = Int(components[2]) else { throw CLIError.invalidFileURL }
                return (path, row, column)

            default: // any other case throw an error since this is invalid
                throw CLIError.invalidFileURL
            }
        }
    }
}
