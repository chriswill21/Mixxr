//
//  FriendsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 6/14/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

import Parse

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet var friendsTableView: UITableView!
    var friends = [""]
    var requests = [String]()
    var table_data = [String]()
    var refresher:UIRefreshControl!
    var num_requests = 0
    
    @IBOutlet var friendsLabel: UILabel!
    @IBOutlet var requestsCountLabel: UILabel!
    @IBOutlet var friendsRequestsSwitch: UISegmentedControl!
    
    var searchUsers: [PFUser] = [PFUser]()
    var searchController:UISearchController!
    var searchActive: Bool = false
    @IBOutlet var searchBar: UISearchBar!
    
    var shouldShowSearchResults = false
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = true
        
        // This is used for dynamic search results updating while the user types
        // Requires UISearchResultsUpdating delegate
        self.searchController.searchResultsUpdater = self
        
        // Configure the search controller's search bar
        self.searchController.searchBar.placeholder = "Find new Mixxes using name or phone number..."
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        
        // Place the search bar view to the tableview headerview.
        friendsTableView.tableHeaderView = searchController.searchBar
    }
    
    
    // MARK: - Parse Backend methods
    
    func loadSearchUsers(searchString: String) {
        var search_query = PFUser.query()
        let test = Int(searchString)
        // Filter by search string
        if test != nil {
            search_query?.whereKey("phonenumber", contains: searchString)
        } else {
            search_query?.whereKey("fullname", contains: searchString)
            
        }
        
        
        self.searchActive = true
        search_query?.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if (error == nil) {
                print(objects)
                self.searchUsers.removeAll(keepingCapacity: false)
                self.searchUsers += objects as! [PFUser]
                self.friendsTableView.reloadData()
            } else {
                // Log details of the failure
                print("search query error")
            }
            self.searchActive = false
        }
    }
    
    // MARK: - Search Bar Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Force search if user pushes button
        let searchString: String = searchBar.text!.lowercased()
        if (searchString != "") {
            loadSearchUsers(searchString: searchString)
        }
        print("clicked")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        // Clear any search criteria
        searchBar.text = ""
        searchUsers = [PFUser]()
        // Force reload of table data from normal data source
        if friendsRequestsSwitch.selectedSegmentIndex == 0{
            table_data = friends
        } else {
            table_data = requests
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchUsers = [PFUser]()
    }


    // MARK: - UISearchResultsUpdating Methods
    
    // This function is used along with UISearchResultsUpdating for dynamic search results processing
    // Called anytime the search bar text is changed
    
    func updateSearchResults(for: UISearchController) {
        let searchString: String = searchController.searchBar.text!.lowercased()
        if (searchString != "" && !self.searchActive) {
            loadSearchUsers(searchString: searchString)
        }
        friendsTableView.reloadData()
    }
    

    //Updates users friends and incoming requests
    public func updateFriends() {
        
        //function updates user's friends list as soon as the app is opend or refreshed by querying the friends class
        let friends_query = PFQuery(className:"friends")
        friends_query.whereKey("phonenumber", equalTo:PFUser.current()?.username)
        

        friends_query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects?.count) records.")
                // Do something with the found objects
                for object in objects! {
                    
                    if object["accepted"]! != nil {
                        self.friends = object["accepted"]! as! Array
                    }
                    self.friendsTableView.reloadData()
                }
                
            } else {
                // Log details of the failure
            }
            self.refresher.endRefreshing()
        }
        
        var requests_query = PFQuery(className:"requests")
        requests_query.whereKey("phonenumber", equalTo:PFUser.current()?.username)
        
        requests_query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects?.count) records.")
                // Do something with the found objects
                for object in objects! {
                    
                    if object["requests"]! != nil {
                        self.requests = object["requests"]! as! Array
                    }
                }
                
                self.num_requests = self.requests.count
                print(self.num_requests)
                if self.num_requests == 0 {
                    self.requestsCountLabel.isHidden = true
                } else {
                    self.friendsLabel.isHidden = false
                    self.friendsLabel.text = String(self.num_requests)
                }

                self.friendsTableView.reloadData()
                
            } else {
                // Log details of the failure
            }
            self.refresher.endRefreshing()
        }
    }
    
    
    
    func refresh() {
        updateFriends()
        print("refreshed")
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        switch friendsRequestsSwitch.selectedSegmentIndex
        {
        case 0:
            table_data = friends
        case 1:
            table_data = requests
        default:
            break;
        }
        friendsTableView.reloadData()
    }
    
    // fixed font style. use custom view (UILabel) if you want something different

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if friendsRequestsSwitch.selectedSegmentIndex == 0{
            return "My Mixxes"
        } else {
            return "Requests"
        }

    }
    
    // MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            // #warning Incomplete method implementation.
            // Return the number of rows in the section.
        
            if (self.searchController.isActive) {
                return self.searchUsers.count
            } else {
                if friendsRequestsSwitch.selectedSegmentIndex == 0{
                    table_data = friends
                } else {
                    table_data = requests
                }
                return self.table_data.count
            }
        }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = self.friendsTableView.dequeueReusableCell(withIdentifier: "friendsCell")! as! FriendingCellsTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendingCellsTableViewCell
        
        if (self.searchController.isActive && self.searchUsers.count > indexPath.row) {
            // bind data to the search results cell
            let first = searchUsers[indexPath.row]["firstname"] as! String
            let last = searchUsers[indexPath.row]["lastname"] as! String
            cell.textLabel?.text = first + " " + last
        } else {
            // bind data from your normal data source
            cell.textLabel?.text = table_data[indexPath.row]
        }
        
        if (self.searchController.isActive) {
            //cell.addButton.isHidden = false
            cell.addButton.setTitle("Add", for: .normal)
        } else if friendsRequestsSwitch.selectedSegmentIndex == 1{
            //cell.addButton.isHidden = false
            cell.addButton.setTitle("Accept/Decline", for: .normal)
        } else {
            //cell.addButton.isHidden = true
            cell.addButton.setTitle("Button", for: .normal)
        }
        return cell
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessoryType = .detailDisclosureButton
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFriends()
        configureSearchController()
        friendsTableView.dataSource = self
        //code below initializes a refresher and adds it above the tableview
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action:#selector(FriendsViewController.refresh), for:UIControlEvents.valueChanged)
        //self.tableView.addSubview(refresher)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    
}
