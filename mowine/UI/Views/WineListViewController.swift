//
//  WineListViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import JFLib
import SwiftyBeaver
import FirebaseCrashlytics

protocol WineListViewControllerDelegate: class {
    func didSelectWine(_ wine: WineListViewModel, at indexPath: IndexPath)
}

protocol WineListThumbnailFetcher: class {
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?>) -> ())
}

class WineListViewController: UITableViewController {
    weak var delegate: WineListViewControllerDelegate?
    weak var thumbnailFetcher: WineListThumbnailFetcher?

    var wines: [WineListViewModel] = [] {
        didSet {
            if wines.isEmpty {
                showEmptyMessage(emptyMessage)
            } else {
                hideEmptyMessage()
            }
            tableView.reloadData()
        }
    }

    var emptyMessage: String = "This is an empty list."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "WineCell", bundle: nil), forCellReuseIdentifier: "WineCell")
        tableView.rowHeight = 104
        tableView.estimatedRowHeight = 104
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func insert(wine: WineListViewModel, at index: Int) {
        SwiftyBeaver.verbose("Insert wine \(wine.id)")
        wines.insert(wine, at: index)
    }
    
    func update(wine: WineListViewModel) {
        SwiftyBeaver.verbose("Update wine \(wine.id)")
        
        if let index = wines.firstIndex(of: wine) {
            wines[index] = wine
            tableView.reloadData()
        }        
    }
    
    func updateThumbnail(_ imageData: Data?, for wineId: String) {
        // Would be nice if I could just update the image view for that particular wine buuuuut this seems to work out okay
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineCell", for: indexPath) as! WineCell
        let wine = wines[indexPath.row]
        cell.configure(wine: wine)
        thumbnailFetcher?.fetchThumbnail(for: wine.id) { result in
            switch result {
            case .success(let data): cell.configure(thumbnail: data)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectWine(wines[indexPath.row], at: indexPath)
    }
}
