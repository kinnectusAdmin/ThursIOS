
//
//  NSLog.swift
//
//  Copyright © 2016 TestFairy. All rights reserved.
//

import Foundation
class NSLog{
    public func NSLog(_ format: String, _ args: CVarArg...) {
        let message = String(format: format, arguments:args)
        print(message);
        TFLogv(message, getVaList([]))
    }
}
