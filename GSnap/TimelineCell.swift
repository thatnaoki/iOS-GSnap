//
//  TimelineCell.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/15.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var post: Post? {
        
        didSet {
            guard let post = post else {return}
            self.postImageView.image = UIImage(named: "noImage")
            self.usernameLabel.text = post.user.name
            self.postTextLabel.text = post.body
            // extensionで用意したメソッドを使ってサブスレッドで画像をダウンロード
            self.avatarImageView.downloadedFrom(path: post.user.avatar_url)
            self.postImageView.downloadedFrom(path: post.image_url)
            
            if post.liked {
                print("liked")
                let image = UIImage(named: "like-on")
                likeButton.setImage(image, for: .normal)
            } else {
                print("not liked yet")
                let image = UIImage(named: "like")
                likeButton.setImage(image, for: .normal)
            }
        }
        
        
    }
    
    var likeCallback: ((Post) -> Void)?
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        print("likebuttonpressed")
        
        guard let post = self.post else {return}
        
        post.liked = !post.liked
        
        if post.liked {
            self.likeButton.setImage(UIImage(named: "like-on"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(named: "like"), for: .normal)
        }
        
        self.likeCallback?(post)
        
//        if likeButton.image(for: .normal) == UIImage(named: "like-on") {
//            let image = UIImage(named: "like")
//            likeButton.setImage(image, for: .normal)
//            Api.unlike(postId: post.id) { message in
//                print(message)
//            }
//        } else if likeButton.image(for: .normal) == UIImage(named: "like") {
//            let image = UIImage(named: "like-on")
//            likeButton.setImage(image, for: .normal)
//            Api.like(postId: post.id) { message in
//                print(message)
//            }
//        }
    }
    
    
}
