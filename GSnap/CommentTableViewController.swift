//
//  CommentTableViewController.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/22.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {

    var post: Post?
    
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Comments"
        self.loadCommentList()

        // コメント追加ボタン
        let navItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onTapAddComment)
        )
        
        self.navigationItem.setRightBarButton(navItem, animated: true)
        
    }
    
    @objc func onTapAddComment() {
        
        let alert = UIAlertController(title: "", message: "コメントを入力", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "コメント"
        }
        
        alert.addAction(UIAlertAction(title: "投稿する", style: .default, handler: { _ in
            
            guard
                let post = self.post,
                let comment = alert.textFields?[0].text else {return}
            
            Api.addComment(postId: post.id, comment: comment, callback: { errorMessage in
                if let errorMessage = errorMessage {
                    self.showAlert(message: errorMessage)
                    return
                }
                self.loadCommentList()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in}))
        
        self.present(alert, animated: true)
        
    }
    
    func loadCommentList() {
        
        guard let post = self.post else {return}
        
        Api.getComments(postId: post.id) { errorMessage, comments in
            
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
            }
            
            if let comments = comments {
                self.comments = comments
                self.tableView.reloadData()
            }
        }
    }
}

    // MARK: - Table view data source

extension CommentTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            
            cell.textLabel?.text = self.post?.body
            
        } else {
            
            let comment = self.comments[indexPath.row]
            cell.textLabel?.text = comment.comment
            
        }
        
        return cell
    }

}
