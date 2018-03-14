//
//  WineListViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

class WineListViewController: UITableViewController {
    var wines: [WineListViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "WineCell", bundle: nil), forCellReuseIdentifier: "WineCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineCell", for: indexPath) as! WineCell
        cell.configure(wine: wines[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
