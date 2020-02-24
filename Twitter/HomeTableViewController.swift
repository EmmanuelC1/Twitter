//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Emmanuel Castillo on 2/16/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //RefreshControl calls loadTweet function when user pulls down to refresh
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        //Dynamic table view height
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Calls loadTweet function
        loadTweets()
    }
    
    @objc func loadTweets() {
        //Sets the number of Tweets to display
        numberOfTweets = 20
        
        //Home timeline Url endpoint
        let homeUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        //Parameters for home timeline enpoint
        let homeParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeUrl, parameters: homeParams, success: { (tweets: [NSDictionary]) in
            
            //Remove all contents in tweetArray
            self.tweetArray.removeAll()
            
            //Append tweet to tweetArray
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            //Reloads data for Table View
            self.tableView.reloadData()
            
            //End the refresh wheel after user pulls down to refresh
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            //Error message
            print("Error: Cannot retrive tweets >> \(Error)")
        })
    }
    
    func loadMoreTweets() {
        //Home timeline Url endpoint
        let homeUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        //Updates numberOfTweets by adding 20
        numberOfTweets = numberOfTweets + 20
        
        //Parameters for home timeline enpoint
        let homeParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeUrl, parameters: homeParams, success: { (tweets: [NSDictionary]) in
            
            //Remove all contents in tweetArray
            self.tweetArray.removeAll()
            
            //Append tweet to tweetArray
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            //Reloads data for Table View
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            //Error message
            print("Error: Cannot retrive tweets (load more tweets)>> \(Error)")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Calls loadMoreTweets if user is at the bottom of the screen (last cell)
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        
        //set UserDefaults to false to succesfully logout user w/o saving session
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        //Sets username to userNameLabel
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        
        //Sets tweet content to tweetContentLabel
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as! String
        
        //Sets profile image to profileImageView
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        //Calls setFavorite function to display correct image
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        //Sets the id of the tweet to tweetID
        cell.tweetID = tweetArray[indexPath.row]["id"] as! Int
        
        //Calls setRetweet function to display correct image
        cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
