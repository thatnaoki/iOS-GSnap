//
//  Extension.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/08.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import UIKit

extension UIViewController {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func showProgress() {
        
        let indicator = UIActivityIndicatorView()
        
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        indicator.center = self.view.center
        
        // 消す時にタグが必要なので適当な値で指定
        indicator.tag = 123
        
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
    }
    
    func hideProgress() {
        // ここでタグを使う
        if let indicator = self.view.viewWithTag(123) {
            
            indicator.removeFromSuperview()
            
        }
        
    }
    
}

extension UIImageView {
    
    func downloadedFrom(path: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        // http:// から始まるフルパスにする.
        let urlString = apiRoot + path
        
        guard let url = URL(string: urlString) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    // 指定URLから画像をダウンロードして、表示します.
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        // ダウンロード先にリクエストを発行します.
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 正しくHTTP通信ができたことを確認します.
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                // メインスレッドで、表示する画像の更新を行います.
                self.image = image
            }
        }.resume()
    }
    
}

