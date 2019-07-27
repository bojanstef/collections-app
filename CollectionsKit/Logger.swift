//
//  Logger.swift
//  CollectionsKit
//
//  Created by Bojan Stefanovic on 2019-07-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import os

private enum Constants {
    static let logFormat: StaticString = "%@ %@ line:%d %@"
    static let pathSeparator: Character = "/"
    static let extensionSeparator: Character = "."
}

public final class Logger {
    fileprivate let log: OSLog

    public init(subsystem: String! = Bundle.main.bundleIdentifier, category: String = .init(describing: Logger.self)) {
        self.log = OSLog(subsystem: subsystem, category: category)
    }

    /// Use this level to capture information about things that might result in a failure.
    public func `default`(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, type: .default, file: file, function: function, line: line)
    }

    /// Use this level to capture information that may be helpful, but isn’t essential, for troubleshooting errors.
    public func info(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, type: .info, file: file, function: function, line: line)
    }

    /// Use this level to capture information that may be useful during development or while troubleshooting a specific problem.
    public func debug(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, type: .debug, file: file, function: function, line: line)
    }

    /// Use this log level to capture process-level information to report errors in the process.
    public func error(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, type: .error, file: file, function: function, line: line)
    }

    /// Use this level to capture system-level or multi-process information to report system errors.
    public func fault(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, type: .fault, file: file, function: function, line: line)
    }
}

fileprivate extension Logger {
    func log(_ message: Any?, type: OSLogType, file: String, function: String, line: Int) {
        let logMessage = "\(message ?? "nil")"
        os_log(Constants.logFormat, log: log, type: type, className(from: file), function, line, logMessage)
    }

    func className(from file: String) -> String {
        // Get `filename` from "/path/to/filename.swift" -> "filename.swift"
        let fileSplitDirectory = file.split(separator: Constants.pathSeparator)
        guard fileSplitDirectory.count > 0 else { return file }
        let filename = fileSplitDirectory[fileSplitDirectory.count - 1]

        // Get `className` from "filename.swift" -> "filename"
        let filenameSplitExtension = filename.split(separator: Constants.extensionSeparator)
        guard filenameSplitExtension.count > 0 else { return String(filename) }
        let className = filenameSplitExtension[0]

        return String(className)
    }
}
