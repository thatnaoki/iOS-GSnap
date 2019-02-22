//
//  MypageViewController.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/22.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import UIKit

class MypageViewController: UICollectionViewController {
    
    var posts: [Post] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Page"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    private func fetchData() {
        
        Api.getTimeLine { (errorMessage, posts) in
            
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
                return
            }
            
            guard let posts = posts else {return}
            
            // 自分のidを取得する
            let userId = UserDefaults.standard.integer(forKey: "userId")
            
            // 自分の投稿に絞る
            self.posts = posts.filter { post -> Bool in
                return post.user.id == userId
            }
        }
    }
}

extension MypageViewController {
    
    // セクション数の指定
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //　セクション内のアイテム数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("cellforitemat called")
        // セルのインスタンス
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // imageviewの取得
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.downloadedFrom(path: self.posts[indexPath.row].image_url)
        }
        
        return cell
    }
    
}

extension MypageViewController: UICollectionViewDelegateFlowLayout {
    
    // セルのサイズを指定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width / 3
        let height = width
        
        return CGSize(width: width, height: height)
        
    }
    
}
