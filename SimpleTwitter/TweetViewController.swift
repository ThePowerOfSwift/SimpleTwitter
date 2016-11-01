//
//  TweetViewController.swift
//  SimpleTwitter
//
//  Created by Jonathan Cheng on 10/30/16.
//  Copyright © 2016 Jonathan Cheng. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, ReplyButtonDatasource, FavouriteButtonDatasource, RetweetButtonDatasource, TweetComposeViewControllerDatasource {

    // Model
    var tweet: Tweet?
    
    // Views
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var retweetButton: RetweetButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouriteCountLabel: UILabel!
    @IBOutlet weak var favouriteButton: FavouriteButton!
    @IBOutlet weak var replyButton: ReplyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Tweet"

        retweetButton.datasource = self
        replyButton.datasource = self
        favouriteButton.datasource = self
        
        if let tweet = tweet {
            favouriteButton.isSelected = tweet.favourited
            retweetButton.isSelected = tweet.retweeted
            retweetCountLabel.text = String(tweet.retweetCount)
            favouriteCountLabel.text = String(tweet.favourtiesCount)
        }
        configureViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureViews() {
        if let tweet = tweet {
            if let text = tweet.text {
                tweetTextLabel.text = text
            }
            
            // Configure user contents
            if let user = tweet.user {
                usernameLabel.text = user.name
                if let url = user.profileURL {
                    profileImageView.setImageWith(url)
                }
                if let screenname = user.screenname {
                    screennameLabel.text = "@\(screenname)"
                }
            }
            
            if let createdAt = tweet.createdAtString {
                timestampLabel.text = createdAt
            }
        }
    }
    
//MARK- protocols
    
    func replyToStatusID(_ sender: UIViewController) -> String? {
        return tweetID(sender)
    }
    
    func tweetID(_ sender: Any) -> String? {
        if let tweet = tweet {
            return tweet.idString
        }
        return nil
    }
 
    func parentVC(_ sender: UIButton) -> UIViewController {
        return self
    }
    
    func replyToUsername(_ sender: UIViewController) -> String? {
        if let screenname = tweet?.user?.screenname {
            return "@" + screenname
        }
        else { return nil }
    }
}
