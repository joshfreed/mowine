//
//  FriendsViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JFLib

protocol FriendsDisplayLogic: class {
    func displayFriends(viewModel: Friends.FetchFriends.ViewModel)
    func displayEmptySearch()
    func displayLoadingSearchResults()
    func displaySearchResults(viewModel: Friends.SearchUsers.ViewModel)
    func displayFriendAdded(viewModel: Friends.AddFriend.ViewModel)
    func displayAddFriendError(viewModel: Friends.AddFriend.ViewModel)
    func displaySelectedUser(viewModel: Friends.SelectUser.ViewModel)
}

class FriendsViewController: UITableViewController, FriendsDisplayLogic {
    var interactor: FriendsBusinessLogic?
    var router: (NSObjectProtocol & FriendsRoutingLogic & FriendsDataPassing)?

    var canSearch = false
    var displayedUsers: [Friends.DisplayedUser] = []
    var userCells: [String: UserTableViewCell] = [:]
    var activityIndicator: UIActivityIndicatorView?
    var activityIndicatorBottom: NSLayoutConstraint?
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = FriendsInteractor()
        let presenter = FriendsPresenter()
        let router = FriendsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = FriendsWorker(
            userRepository: Container.shared.userRepository,
            session: Container.shared.session
        )
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpActivityIndicator()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for friends"
        searchController.searchBar.tintColor = .mwButtonSecondary
        searchController.searchBar.setSearchFieldColor(.white)        

        navigationItem.searchController = searchController
        definesPresentationContext = true
        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for friends", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        fetchFriendsOnLoad()
    }
    
    private func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator!.hidesWhenStopped = true
        view.addSubview(activityIndicator!)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator!.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        activityIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)                
        navigationItem.largeTitleDisplayMode = .automatic
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! UserTableViewCell
        cell.delegate = self
        cell.configure(user: displayedUsers[indexPath.row])
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = displayedUsers[indexPath.row].userId
        
        let request = Friends.SelectUser.Request(userId: userId)
        interactor?.selectUser(request: request)
    }

    // MARK: Fetch friends

    func fetchFriendsOnLoad() {
        activityIndicator?.startAnimating()
        fetchFriends()
    }
    
    func fetchFriends() {
        let request = Friends.FetchFriends.Request()
        interactor?.fetchFriends(request: request)
    }

    func displayFriends(viewModel: Friends.FetchFriends.ViewModel) {
        activityIndicator?.stopAnimating()
        displayedUsers = viewModel.friends
        
        if displayedUsers.count > 0 {
            hideEmptyMessageFromHeader()
        } else {
            showEmptyMessageInHeader("You don't have any friends, loser.")
        }
        
        tableView.reloadData()
    }
    
    // MARK: Search users
    
    func searchUsers(searchString: String) {
        let request = Friends.SearchUsers.Request(searchString: searchString)
        interactor?.searchUsers(request: request)
    }
    
    func displayLoadingSearchResults() {
        activityIndicator?.startAnimating()
        displayedUsers = []
        hideEmptyMessageFromHeader()
        tableView.reloadData()
    }
    
    func displaySearchResults(viewModel: Friends.SearchUsers.ViewModel) {
        activityIndicator?.stopAnimating()
        displayedUsers = viewModel.matches
        
        if displayedUsers.count > 0 {
            hideEmptyMessageFromHeader()
        } else {
            showEmptyMessageInHeader("No users match your search.")
        }        
        
        tableView.reloadData()
    }
    
    func displayEmptySearch() {
        displayedUsers = []
        showEmptyMessageInHeader("Try searching for people you know")
        tableView.reloadData()
    }
    
    // MARK: Add friend
    
    var friendCells: [String: UserTableViewCell] = [:]
    
    func addFriend(userId: String) {
        let request = Friends.AddFriend.Request(userId: userId)
        interactor?.addFriend(request: request)
    }
    
    func displayFriendAdded(viewModel: Friends.AddFriend.ViewModel) {
        if let index = displayedUsers.index(where: { $0.userId == viewModel.userId }) {
            displayedUsers[index].isFriend = true
        }
        friendCells[viewModel.userId]?.displayFriendAdded()
    }
    
    func displayAddFriendError(viewModel: Friends.AddFriend.ViewModel) {
        friendCells[viewModel.userId]?.displayAddFriendFailed()
        // TODO: display an error message
    }
    
    // MARK: Select user
    
    func displaySelectedUser(viewModel: Friends.SelectUser.ViewModel) {
        performSegue(withIdentifier: "UserProfile", sender: nil)
    }
}

// MARK: - UISearchResultsUpdating
extension FriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard canSearch else {
            return
        }

        print("updateSearchResults(for:)")

        let text = searchController.searchBar.text ?? ""
        searchUsers(searchString: text)
    }
}

extension FriendsViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        displayEmptySearch()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        canSearch = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        canSearch = false
        interactor?.cancelSearch()
    }
}

extension FriendsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        searchUsers(searchString: text)
    }
}

extension FriendsViewController: UserTableViewCellDelegate {
    func addFriend(cell: UserTableViewCell, userId: String) {
        friendCells[userId] = cell
        addFriend(userId: userId)
    }
}



public extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public func withRoundCorners(_ cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        context?.beginPath()
        context?.addPath(path.cgPath)
        context?.closePath()
        context?.clip()
        
        draw(at: CGPoint.zero)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}
