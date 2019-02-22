//
//  PostViewController.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/15.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textviewのdelegate設定
        self.textView.delegate = self
    }
    
    @IBAction func onTapCamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            self.showAlert(message: "Cannot lauch camera.")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
        
    }
    
    @IBAction func onTapLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false{
            self.showAlert(message: "cannot access to library.")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true)
        
    }
    
    @IBAction func onTapPost(_ sender: Any) {
        // 投稿画像の取得
        guard let image = self.postImageView.image else {return}
        // 投稿テキストの取得
        guard let text = self.textView.text else {return}
        
        // APIを呼ぶ
        Api.post(image: image, text: text) { errorMessage in
            
            if let message = errorMessage {
                self.showAlert(message: message)
                return
            }
            // 成功
            self.showAlert(message: "投稿完了")
            
            // タイムラインへの遷移
            self.navigationController?.tabBarController?.selectedIndex = 0
        }
    }
}

extension PostViewController: UINavigationControllerDelegate {
    
    
    
}

extension PostViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}


extension PostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // close picker
        picker.dismiss(animated: true, completion: nil)
        
        // get picture
        if let image = info[.originalImage] as? UIImage {
            let croppedImage = self.cropRect(image: image)
            
            self.postImageView.image = croppedImage
            
        }
    }
    
}

extension PostViewController {
    
    // 画像を正方形にクロップする.
    private func cropRect(image: UIImage) -> UIImage {
        
        // 加工対象の画像.
        var image = image
        
        // 天地が反転している場合があるので、対応しておく.
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        if let _image = UIGraphicsGetImageFromCurrentImageContext() {
            image = _image
        }
        UIGraphicsEndImageContext()
        
        // 正方形にクロップする.
        if image.size.width != image.size.height {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var w = image.size.width
            var h = image.size.height
            if w > h {
                // 横長の場合.
                x = (w - h) / 2
                w = h
            } else {
                // 縦長の場合.
                y = (h - w) / 2
                h = w
            }
            let cgImage = image.cgImage?.cropping(to: CGRect(x: x, y: y, width: w, height: h))
            image = UIImage(cgImage: cgImage!)
        }
        
        // サイズが大きすぎても困るので、小さくしておく.
        let newSize = CGSize(width: 720, height: 720)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        if let _image = UIGraphicsGetImageFromCurrentImageContext() {
            image = _image
        }
        UIGraphicsEndImageContext()
        
        // 返却する.
        return image
    }
}
