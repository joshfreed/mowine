//
//  StringProtocol.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation

public extension StringProtocol {
    var words: [SubSequence] {
        split { !$0.isLetter && !$0.isNumber }
    }
}
