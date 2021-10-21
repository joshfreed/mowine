//
//  DependencyInjection.swift
//  
//
//  Created by Josh Freed on 10/21/21.
//

import Foundation
import Dip

public class DependencyInjection {
    public static func registerServices(container: DependencyContainer) {
        // Auth
        container.register(.singleton) { SocialSignInRegistryImpl() }.implements(SocialSignInRegistry.self)
        container.register { SocialUserCreator(userRepository: $0, session: $1) }
        container.register(.unique) { SocialAuthApplicationService(auth: $0, userFactory: $1, socialSignIn: $2) }
        container.register(.unique) { SignOutCommand(session: $0) }
        container.register(.unique) { EmailAuthApplicationService(emailAuthService: $0, userRepository: $1, session: $2) }

        // Users
        container.register(.unique) { GetUserCellarQuery(wineTypeRepository: $0, wineRepository: $1) }
        container.register(.singleton) { GetMyAccountQueryHandler(userRepository: $0, session: $1) }.implements(GetMyAccountQuery.self)
        container.register(.singleton) { UsersService(session: $0, userRepository: $1) }
        container.register { UpdateProfileCommandHandler(session: $0, userRepository: $1, createProfilePicture: $2) }
        container.register { CreateProfilePictureCommandHandler(userImageStorage: $0, imageResizer: $1, userRepository: $2) }

        // Wines
        container.register(.unique) { UpdateWineCommandHandler(wineRepository: $0, wineTypeRepository: $1, createWineImages: $2) }
        container.register(.unique) { DeleteWineCommandHandler(wineRepository: $0) }
        container.register(.unique) { GetWineImageQueryHandler(wineImageStorage: $0) }
        container.register(.unique) { GetWineThumbnailQueryHandler(wineImageStorage: $0) }
        container.register(.unique) { GetWineByIdQueryHandler(wineRepository: $0) }
        container.register(.unique) { GetWineTypesQueryHandler(wineTypeRepository: $0) }
        container.register(.singleton) { GetTopWinesQuery(wineRepository: $0) }
        container.register(.singleton) { GetUserWinesByTypeQuery(wineRepository: $0) }
        container.register(.singleton) { GetWineDetailsQuery(wineRepository: $0) }
        container.register(.singleton) { MyWinesService(session: $0, wineTypeRepository: $1, wineRepository: $2) }
        container.register(.singleton) { CreateWineCommandHandler(wineRepository: $0, session: $1, createWineImages: $2, wineTypeRepository: $3) }
        container.register(.unique) { SearchMyCellarQuery(wineRepository: $0, session: $1) }
        container.register(.unique) { CreateWineImagesCommandHandler(wineImageStorage: $0, imageResizer: $1) }

        // Friends
        container.register(.singleton) { FriendsService(session: $0, userRepository: $1) }
    }
}
