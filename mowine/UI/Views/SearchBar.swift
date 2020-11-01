//
//  SearchBar.swift
//  SwiftUI_Search_Bar_in_Navigation_Bar
//
//  Created by Geri Borbás on 2020. 04. 27..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import SwiftUI

class SearchBar: NSObject, ObservableObject {
    @Published var text: String = ""
    @Published var isActive: Bool = false
    let searchController: UISearchController = UISearchController(searchResultsController: nil)

    override init() {
        super.init()
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .mwButtonSecondary
        searchController.searchBar.setSearchFieldColor(.white)
    }
}

extension SearchBar: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
        }
    }
}

extension SearchBar: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        isActive = true
    }

    func didPresentSearchController(_ searchController: UISearchController) {

    }

    func willDismissSearchController(_ searchController: UISearchController) {

    }

    func didDismissSearchController(_ searchController: UISearchController) {
        isActive = false
    }
}

struct SearchBarModifier: ViewModifier {
    let searchBar: SearchBar

    func body(content: Content) -> some View {
        content
            .overlay(
            ViewControllerResolver { viewController in
                viewController.navigationItem.searchController = self.searchBar.searchController
            }
                .frame(width: 0, height: 0)
        )
    }
}

extension View {
    func add(_ searchBar: SearchBar) -> some View {
        modifier(SearchBarModifier(searchBar: searchBar))
    }
}
