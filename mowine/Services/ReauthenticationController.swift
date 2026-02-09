import Foundation
import Combine
import MoWine_Application

@MainActor
@Observable
final class ReauthenticationController {
    var isPresenting = false

    private var waiters: [CheckedContinuation<Void, Error>] = []
    private var isInProgress = false

    // Callers await this when re-auth is needed
    func requireReauthentication() async throws {
        if isInProgress {
            // Another re-auth is already presented; just wait.
            return try await withCheckedThrowingContinuation { cont in
                waiters.append(cont)
            }
        }

        isPresenting = true
        isInProgress = true

        return try await withCheckedThrowingContinuation { cont in
            waiters.append(cont)
        }
    }

    // Call from the re-auth UI on success
    func completeSuccessfully() {
        endPresentation(resume: { $0.resume() })
    }

    // Call from the re-auth UI on failure/cancel
    func fail(_ error: Error) {
        endPresentation(resume: { $0.resume(throwing: error) })
    }

    private func endPresentation(resume: (CheckedContinuation<Void, Error>) -> Void) {
        isPresenting = false
        isInProgress = false
        let continuations = waiters
        waiters.removeAll()
        continuations.forEach(resume)
    }

    // The reusable wrapper: run an operation, prompt and retry if needed.
    func withReauthenticationRetry<T>(
        maxRetries: Int = 1,
        _ operation: @escaping () async throws -> T
    ) async throws -> T {
        var attempts = 0
        while true {
            do {
                return try await operation()
            } catch {
                guard case SessionError.requiresRecentLogin = error, attempts < maxRetries else {
                    throw error
                }
                attempts += 1
                try await requireReauthentication()
                // loop and retry
            }
        }
    }
}
