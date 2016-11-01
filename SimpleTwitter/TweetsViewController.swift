//
//  TweetsViewController.swift
//  SimpleTwitter
//
//  Created by Jonathan Cheng on 10/29/16.
//  Copyright © 2016 Jonathan Cheng. All rights reserved.
//

import UIKit
import AFNetworking

let kTweetsTableViewCellIdentifier = "TweetTableViewCell"
let kTweetsComposeNavigationControllerName = "TweetNavigationController"
class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet] = []
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "Timeline"

        // Initialize a pull to refresh UIRefreshControl
        refreshControl.addTarget(self, action: #selector(fetchTimeline), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // load the model and views
        fetchTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        
        if destinationVC.isKind(of: TweetViewController.classForCoder()) {
            (destinationVC as! TweetViewController).tweet = tweets[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
//MARK- Model
    func fetchTimeline () {
        TwitterSessionManager.sharedInstance.fetchTimeline(completion: { (response) in
            if let response = response {
                self.tweets = response
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
// MARK: - tableView methods

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTweetsTableViewCellIdentifier, for: indexPath) as! TweetTableViewCell
        
        // Set model
        let tweet = tweets[indexPath.row]
        
        // Configure cell
        if let text = tweet.text {
            cell.tweetTextLabel.text = text
        }

        // Configure user contents
        if let user = tweet.user {
            cell.usernameLabel.text = user.name
            if let url = user.profileURL {
                cell.profileImageView.setImageWith(url)
            }
        }
        
        if let timeSince = tweet.timeSinceNowString {
            cell.timestampLabel.text = timeSince
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

// MARK: Actions
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        TwitterSessionManager.sharedInstance.logout()
    }
    
    @IBAction func composeButtonTapped(_ sender: UIBarButtonItem) {
        TweetComposeViewController.present(from: self)
    }
}
