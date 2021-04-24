//
//  MainTabBarData.swift
//  
//
//  Created by Josh Freed on 4/22/21.
//

import Foundation

public final class MainTabBarData: ObservableObject {
    /// This is true when the user has selected the Item with the custom action
    @Published public var isCustomItemSelected: Bool = false

    /// The index of the currently selected tab
    @Published public var itemSelected: Int {
        didSet {
            if itemSelected == customActionItemIndex {
                previousItem = oldValue
                itemSelected = oldValue
                isCustomItemSelected = true
            }
        }
    }

    /// This is the index of the item that fires a custom action
    let customActionItemIndex: Int

    private var previousItem: Int

    public init(customItemIndex: Int, initialIndex: Int = 1) {
        self.customActionItemIndex = customItemIndex
        self.itemSelected = initialIndex
        self.previousItem = initialIndex
    }
}
