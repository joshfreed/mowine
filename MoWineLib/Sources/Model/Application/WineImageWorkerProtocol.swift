//
//  WineImageWorkerProtocol.swift
//  
//
//  Created by Josh Freed on 4/24/21.
//

import Foundation
import UIKit.UIImage

public protocol WineImageWorkerProtocol {
    func createImages(wineId: WineId, photo: UIImage?) -> Data?
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?, Error>) -> ())
    func fetchPhoto(wine: Wine, completion: @escaping (Result<Data?, Error>) -> ())
}
