import Foundation

public class DeleteAccountService {
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }

    public func deleteAccount() async throws {
        try await session.deleteAccount()
    }
}
