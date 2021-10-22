//
//  File.swift
//  
//
//  Created by Josh Freed on 10/22/21.
//

import XCTest
import JFLib_Mediator

class MediatorTests: XCTestCase {
    let mediator = Mediator()
    let commandOutput = CommandOutput()

    override func setUpWithError() throws {
        mediator.registerHandler(SampleCommandHandler(output: self.commandOutput), for: SampleCommand1.self)
        mediator.registerHandler(SampleQueryHandler(), for: SampleQuery1.self)
    }

    func test_command() async throws {
        try await mediator.send(SampleCommand1(value: 1))
        XCTAssertEqual(1, commandOutput.lastValue)
    }

    func test_commandHandlerNotFound() async throws {
        do {
            try await mediator.send(NotRegisteredCommand())
            XCTFail("Expected to throw execption")
        } catch is HandlerNotFound {
            // Success!
        }
    }

    func test_query() async throws {
        let result: SampleQueryResponse = try await mediator.send(SampleQuery1(value: 1))

        XCTAssertEqual(1, result.input)
        XCTAssertEqual("My Result", result.other)
    }

    func test_queryHandlerNotFound() async throws {
        do {
            let _: Any = try await mediator.send(NotRegisteredQuery())
            XCTFail("Expected to throw execption")
        } catch is HandlerNotFound {
            // Success!
        }
    }
}

// MARK: Sample Commands

struct SampleCommand1: JFMCommand {
    let value: Int
}

struct NotRegisteredCommand: JFMCommand {}

class SampleCommandHandler: BaseCommandHandler<SampleCommand1> {
    let output: CommandOutput

    init(output: CommandOutput) {
        self.output = output
    }

    override func handle(command: SampleCommand1) async throws {
        output.lastValue = command.value
    }
}

class CommandOutput {
    var lastValue: Int?
}

// MARK: Sample Queries

struct SampleQuery1: JFMQuery {
    let value: Int
}

struct NotRegisteredQuery: JFMQuery {}

class SampleQueryHandler: BaseQueryHandler<SampleQuery1, SampleQueryResponse> {
    override func handle(query: SampleQuery1) async throws -> SampleQueryResponse {
        SampleQueryResponse(input: query.value)
    }
}

struct SampleQueryResponse {
    let input: Int
    let other = "My Result"
}
