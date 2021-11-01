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
import MoWine_Application
import UIKit.UIImage
import UIKit
import JFLib_Mediator

@MainActor
class EditWineViewModel: ObservableObject {
    @Published var isSaving = false
    @Published var isShowingSheet = false
    @Published var pickerSourceType: ImagePickerView.SourceType = .camera
    
    let form = EditWineFormModel()
    private var wineId: String!
    @Injected private var mediator: Mediator

    init() {
        SwiftyBeaver.debug("init")
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func load(wineId: String) async {
        self.wineId = wineId

        async let getWineTypesResponse: GetWineTypesQueryResponse = mediator.send(GetWineTypesQuery())
        async let getWineResponse: GetWineByIdQueryResponse? = mediator.send(GetWineByIdQuery(wineId: wineId))
        async let wineImage: Data? = mediator.send(GetWineImageQuery(wineId: wineId))

        do {
            let wineTypes = EditWine.mapTypes(from: try await getWineTypesResponse)
            form.setTypes(wineTypes)
        } catch {
            CrashReporter.shared.record(error: error)
        }

        do {
            if let response = try await getWineResponse {
                let wine = EditWine.mapWine(from: response)
                form.setWine(wine)
            } else {
                // Wine was not found. What to do?
                SwiftyBeaver.error("Wine \(wineId) was not found")
            }
        } catch {
            CrashReporter.shared.record(error: error)
        }

        do {
            if let imageData = try await wineImage {
                form.image = UIImage(data: imageData)
            }
        } catch {
            CrashReporter.shared.record(error: error)
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
            try await mediator.send(command)
        } catch {
            CrashReporter.shared.record(error: error)
            throw error
        }
    }

    func deleteWine() async throws {
        do {
            try await mediator.send(DeleteWineCommand(wineId: wineId))
        } catch {
            CrashReporter.shared.record(error: error)
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

struct EditWine {
    struct Wine: Equatable, Identifiable {
        let id: String
        let name: String
        let rating: Int
        let typeId: Int
        let varietyId: Int?
        let location: String
        let price: String
        let notes: String
        let pairings: [String]
    }

    static func mapWine(from response: GetWineByIdQueryResponse) -> Wine {
        Wine(
            id: response.id,
            name: response.name,
            rating: response.rating,
            typeId: response.typeId,
            varietyId: response.varietyId,
            location: response.location,
            price: response.price,
            notes: response.notes,
            pairings: response.pairings
        )
    }

    struct WineType: Equatable, Identifiable {
        let id: Int
        let name: String
        let varieties: [WineVariety]
    }

    struct WineVariety: Equatable, Identifiable {
        let id: Int
        let name: String
    }

    static func mapTypes(from response: GetWineTypesQueryResponse) -> [WineType] {
        response.wineTypes.map { typeModel in
            let varieties = typeModel.varieties.map { EditWine.WineVariety(id: $0.id, name: $0.name) }
            return WineType(id: typeModel.id, name: typeModel.name, varieties: varieties)
        }
    }
}
