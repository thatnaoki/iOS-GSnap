//
//  TimelineTableViewController.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/08.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {

    var posts : [Post] = []
    
    override func viewDidLoad() {
        // set title
        self.title = "Timeline"
        
        // register custom cell
        self.tableView.register(UINib(nibName: "TimelineCell", bundle: nil), forCellReuseIdentifier: "TimelineCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }

    private func fetchData() {
        
        Api.getTimeLine { (errorMessage, data) in
            
            if let message = errorMessage {
                self.showAlert(message: message)
                return
            }
            if let data = data {
                print(data)
                self.posts = data
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as! TimelineCell
            
        cell.post = self.posts[indexPath.row]
        
        cell.likeCallback = { post in
            
            if post.liked {
                Api.like(postId: post.id, callback: { errorMessage in
                    if let errorMessage = errorMessage {
                        self.showAlert(message: errorMessage)
                    }
                })
            } else {
                Api.unlike(postId: post.id, callback: { errorMessage in
                    if let errorMessage = errorMessage {
                        self.showAlert(message: errorMessage)
                    }
                })
            }
        }
            
        return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = self.posts[indexPath.row]
        
        self.performSegue(withIdentifier: "comments", sender: post)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CommentTableViewController{
            
            if let post = sender as? Post {
                vc.post = post
            }
            
        }
        
    }

}
