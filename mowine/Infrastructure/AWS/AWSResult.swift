//
//  AWSResult.swift
//  mowine
//
//  Created by Josh Freed on 3/28/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

struct AWSResult {
    let result: Any?
    let error: Error?
    
    var isError: Bool {
        return error != nil
    }
    
    var errorType: String {
        guard let e = error else {
            return ""
        }
        let nserror = e as NSError
        return (nserror.userInfo["__type"] as? String) ?? ""
    }
    
    var errorMessage: String {
        guard let e = error else {
            return ""
        }
        let nserror = e as NSError
        return (nserror.userInfo["message"] as? String) ?? ""
    }
}
