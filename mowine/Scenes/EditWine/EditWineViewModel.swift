//
//  EditWineViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import FirebaseCrashlytics
import Model
import UIKit.UIImage
import UIKit

@MainActor
class EditWineViewModel: ObservableObject {
    @Published var isSaving = false
    @Published var isShowingSheet = false
    @Published var pickerSourceType: ImagePickerView.SourceType = .camera
    
    let form = EditWineFormModel()
    private var wineId: String
    @Injected private var getWineTypesQuery: GetWineTypesQueryHandler
    @Injected private var getWineQuery: GetWineByIdQueryHandler
    @Injected private var getWineImageQuery: GetWineImageQueryHandler
    @Injected private var updateWineCommandHandler: UpdateWineCommandHandler
    @Injected private var deleteWineCommandHandler: DeleteWineCommandHandler
    
    init(wineId: String) {
        SwiftyBeaver.debug("init")
        self.wineId = wineId
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func load() async {
        async let wineTypes = getWineTypesQuery.handle()
        async let wine = getWineQuery.handle(wineId: wineId)
        async let wineImage = getWineImageQuery.handle(wineId: wineId)

        do {
            form.setTypes(try await wineTypes)
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }

        do {
            if let wine = try await wine {
                form.setWine(wine)
            } else {
                // Wine was not found. What to do?
                SwiftyBeaver.error("Wine \(wineId) was not found")
            }
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }

        do {
            if let imageData = try await wineImage {
                form.image = UIImage(data: imageData)
            }
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }
    }

    func save() async throws {
        guard let type = form.type else {
            // Validation failure. Wines require a type to be selected.
            return
        }

        isSaving = true

        var command = UpdateWineCommand(wineId: wineId, name: form.name, rating: Double(form.rating), type: type.name)
        command.variety = form.variety?.name
        command.location = form.location
        command.price = form.price
        command.notes = form.notes
        command.pairings = form.pairings
        command.image = form.image?.pngData()

        defer {
            isSaving = false
        }

        do {
            try await updateWineCommandHandler.handle(command)
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
            throw error
        }
    }

    func deleteWine() async throws {
        do {
            try await deleteWineCommandHandler.handle(wineId)
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
            throw error
        }
    }

    func selectWinePhoto(from sourceType: ImagePickerView.SourceType) {
        isShowingSheet = true
        pickerSourceType = sourceType
    }
    
    func changeWinePhoto(to image: UIImage) {
        form.image = image
        isShowingSheet = false
    }
    
    func cancelSelectWinePhoto() {
        isShowingSheet = false
    }
}
