//
//  FriendsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 6/14/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet var friendsTableView: UITableView!
    //var friends = [""]
    var friends = [String]()
    var friend_user: [PFObject] = [PFObject]()      //array containing PF objects for friends
    var requests = [String]()
    var request_user: [PFObject] = [PFObject]()     //array containing PF object for requests
    
    var table_data = [String]()
    var refresher:UIRefreshControl!
    var num_requests = 0
    var screen = 0
    var my_request = PFUser()
    
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
        self.searchController.dimsBackgroundDuringPresentation = false
        
        // This is used for dynamic search results updating while the user types
        // Requires UISearchResultsUpdating delegate
        self.searchController.searchResultsUpdater = self
        
        // Configure the search controller's search bar
        self.searchController.searchBar.placeholder = "Find new Mixxes using name or phone number..."
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = false

        
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
                //print(objects)
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
        friends_query.whereKey("of", equalTo:PFUser.current())

        friends_query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if (error == nil) {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects?.count) records.")
                
                // Do something with the found objects
                self.friend_user.removeAll(keepingCapacity: false)
                self.friend_user += objects as [PFObject]!
                
            } else {
                // Log details of the failure
                print("friend query error")
            }
            self.friends.removeAll()
            for friend in self.friend_user{
                let my_friend = friend["fullname"]
                self.friends.append(my_friend as! String)
            }
            self.friendsTableView.reloadData()
            self.refresher.endRefreshing()
        }
        
        
        //ensure that requests array (of strings) is empty every time you do a request query
        let requests_query = PFQuery(className:"request")
        requests_query.whereKey("to", equalTo:PFUser.current()!)
        
        requests_query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if (error == nil) {
                self.request_user.removeAll(keepingCapacity: false)
                self.request_user += objects as [PFObject]!
            } else {
                // Log details of the failure
                print("request query error")
            }
            
            self.requests.removeAll()

            for request in self.request_user{
                let made_request = request["fullname"]
                self.requests.append(made_request as! String)
            }
            self.num_requests = self.requests.count
            if self.num_requests == 0 {
                self.requestsCountLabel.isHidden = true
            } else {
                self.requestsCountLabel.isHidden = false
                self.requestsCountLabel.text = String(self.num_requests)
            }
            self.friendsTableView.reloadData()
            
            //print("we gone find requests")
            //print(self.requests.count)
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
    
    
    func makeRequest(otherUser: PFUser) {
        let follow = PFObject(className: "request")
        follow.setObject(PFUser.current()!, forKey: "from")
        follow.setObject(otherUser, forKey: "to")
        follow.setObject(NSDate(), forKey: "date")
        follow.setObject(PFUser.current()?["fullname"] as! String, forKey: "fullname")
        follow.setObject(PFUser.current()?["phonenumber"] as! String, forKey: "phonenumber")
        
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.getPublicWriteAccess = true
        follow.acl = acl
        follow.saveInBackground()
        
    }
    
    func acceptRequest(otherUser: PFUser, index: Int, other_user_name: String, other_user_number: String) {
        let follow_1 = PFObject(className: "friends")
        
        //set other user to be follower OF current user
        follow_1.setObject(PFUser.current()!, forKey: "of")
        follow_1.setObject(otherUser, forKey: "user")
        follow_1.setObject(other_user_name , forKey: "fullname")
        follow_1.setObject(other_user_number , forKey: "phonenumber")
        
        
        let follow_2 = PFObject(className: "friends")
        //set current user to be follower OF other user
        follow_2.setObject(otherUser, forKey: "of")
        follow_2.setObject(PFUser.current()!, forKey: "user")
        follow_2.setObject(PFUser.current()?["fullname"] as! String, forKey: "fullname")
        follow_2.setObject(PFUser.current()?["phonenumber"] as! String, forKey: "phonenumber")
        
        //remove request users of the index that i pressed
        self.request_user[index].deleteInBackground()
        
        
        
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.getPublicWriteAccess = true
        follow_1.acl = acl
        follow_2.acl = acl
        follow_1.saveInBackground()
        follow_2.saveInBackground()
        
        updateFriends()
        friendsTableView.reloadData()
    }
    
    
    func declineRequest(index: Int){
        self.request_user[index].deleteInBackground()
        updateFriends()
        friendsTableView.reloadData()
    }
    
    func deleteFriend(index: Int){
        self.friend_user[index].deleteInBackground()

        let friend_delete_query = PFQuery(className:"friends")
        friend_delete_query.whereKey("of", equalTo:friend_user[index]["user"])
        friend_delete_query.whereKey("user", equalTo:PFUser.current())
        
        friend_delete_query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if (error == nil) {
                if (objects?.count)! > 0{
                    objects?[0].deleteInBackground()
                }
            } else {
                // Log details of the failure
                print("friend deletion/query error")
            }
        }
        
        updateFriends()
        friendsTableView.reloadData()
    }
    
    // fixed font style. use custom view (UILabel) if you want something different

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.searchController.isActive {
            return "Search"
        } else if friendsRequestsSwitch.selectedSegmentIndex == 0{
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
            //cell.textLabel?.text = first + " " + last
            cell.fullName.text? = first + " " + last
            cell.phoneNumber.text? = searchUsers[indexPath.row]["phonenumber"] as! String

        } else {
            if friendsRequestsSwitch.selectedSegmentIndex == 0 {
                // bind data from your normal data source
                cell.phoneNumber.text? = " "
                cell.fullName?.text = table_data[indexPath.row]
                print(table_data)
            } else {
                cell.fullName.text? = self.requests[indexPath.row]
                //cell.phoneNumber.text? = request_user[indexPath.row]["phonenumber"] as! String
            }
            
        }
        
        
        cell.addButton.tag = indexPath.row
        cell.otherButtonOutlet.tag = indexPath.row
        

        cell.addButton.addTarget(self, action: #selector(FriendsViewController.friendAction(sender:)), for: .touchUpInside)
        cell.otherButtonOutlet.addTarget(self, action: #selector(FriendsViewController.friendActionOther(sender:)), for: .touchUpInside)
        
        
        if (self.searchController.isActive) {
            cell.addButton.isHidden = false
            cell.otherButtonOutlet.isHidden = true
            
            
            cell.addButton.setTitle("add", for: .normal)
            cell.addButton.titleLabel?.font =  UIFont(name: "Futura", size: 12)
            
            screen = -1
            my_request = searchUsers[indexPath.row]
            
        } else if friendsRequestsSwitch.selectedSegmentIndex == 1{
            
            cell.addButton.isHidden = false
            cell.otherButtonOutlet.isHidden = false
            
            cell.addButton.setTitle("Decline", for: .normal)
            cell.addButton.titleLabel?.font =  UIFont(name: "Futura", size: 12)
            cell.otherButtonOutlet.setTitle("Accept", for: .normal)
            cell.otherButtonOutlet.titleLabel?.font =  UIFont(name: "Futura", size: 12)
            
            //print(self.request_user)
            screen = 1
        } else {
            cell.addButton.isHidden = false
            cell.otherButtonOutlet.isHidden = true
            cell.addButton.setTitle("Info", for: .normal)
            
            screen = 0
        }
        
        return cell
    }
    
    
    @IBAction func friendAction(sender: UIButton) {
        if screen == -1{
            if let cell = sender.superview?.superview as? FriendingCellsTableViewCell {
                let indexPath = friendsTableView.indexPath(for: cell)
                let val = indexPath?[1]
                let user_to_add = self.searchUsers[Int(val!)]
                makeRequest(otherUser: user_to_add)
                cell.addButton.setTitle("Added", for: .normal)
                cell.addButton.titleLabel?.textColor = UIColor.red
            }
            
        } else if screen == 1 {
            if let cell = sender.superview?.superview as? FriendingCellsTableViewCell {
                let indexPath = friendsTableView.indexPath(for: cell)
                let val = indexPath?[1]
                declineRequest(index: val!)
            }
        } else {
            
            if let cell = sender.superview?.superview as? FriendingCellsTableViewCell {
                let indexPath = friendsTableView.indexPath(for: cell)
                let val = indexPath?[1]
                let alertView = SCLAlertView()
                //alertView.addButton("First Button", target:self, selector:Selector("firstButton"))
                alertView.addButton("Delete Friend?") {
                    print("Delete Friend")
                    self.deleteFriend(index: val!)
                }
                alertView.showSuccess(friends[val!], subTitle: "")
                
                //SCLAlertView().showInfo("Important info", subTitle: "You are great")
            }
            
        }
    }
    
    @IBAction func friendActionOther(sender: UIButton) {
        if let cell = sender.superview?.superview as? FriendingCellsTableViewCell {
            let indexPath = friendsTableView.indexPath(for: cell)
            let val = indexPath?[1]
            let object_to_add = self.request_user[Int(val!)]
            let user_to_add = object_to_add["from"]
            let full_name = object_to_add["fullname"] as! String
            let phonenumber = object_to_add["phonenumber"] as! String
            acceptRequest(otherUser: user_to_add as! PFUser, index: val!, other_user_name: full_name, other_user_number: phonenumber)
        }
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
