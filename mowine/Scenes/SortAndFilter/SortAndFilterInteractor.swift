//
//  SortAndFilterInteractor.swift
//  mowine
//
//  Created by Josh Freed on 3/18/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SortAndFilterInteractorInput {
    func doSomething(request: SortAndFilter.Something.Request)
}

protocol SortAndFilterInteractorOutput {
    func presentSomething(response: SortAndFilter.Something.Response)
}

class SortAndFilterInteractor: SortAndFilterInteractorInput {
    var output: SortAndFilterInteractorOutput!
    var worker: SortAndFilterWorker!

    // MARK: - Business logic

    func doSomething(request: SortAndFilter.Something.Request) {
        // NOTE: Create some Worker to do the work

        worker = SortAndFilterWorker()
        worker.doSomeWork()

        // NOTE: Pass the result to the Presenter

        let response = SortAndFilter.Something.Response()
        output.presentSomething(response: response)
    }
}
