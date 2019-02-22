//
//  Api.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/08.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import Alamofire
//コールバックの型に名前をつける
typealias LoginCallback = (String?) -> Void

let apiRoot = "http://gsnap.yoheim.tech"


struct Api {
    
    static func login(id: String, password: String, callback: @escaping(LoginCallback)) {
        
        let url = apiRoot + "/api/login"
        
        let params = [
        
            "login_id" : id,
            "password" : password
        
        ]
        
        let request = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
        
        request.responseJSON { responseData in
            
            if responseData.result.isFailure {
                
                print("エラー \(String(describing: responseData.error))")
                callback("エラーが発生しました")
                return
                
            }
            
            guard let statusCode = responseData.response?.statusCode else {
                return
            }
            
            guard let data = responseData.result.value as? [String : Any] else {
                return
            }
            
            if statusCode != 200 {
                
                if let message = data["message"] as? String {
                    callback(message)
                }
                return
            }
            
            if let userId = data["id"] as? Int {
                UserDefaults.standard.set(userId, forKey: "userId")
            }
            
            if let apiToken = data["api_token"] as? String {
                UserDefaults.standard.set(apiToken, forKey: "apiToken")
            }
            
            callback(nil)
            
        }
        
    }
    
    static func getTimeLine(callback: @escaping((String?, [Post]?) -> Void)) {
        
        guard let apiToken = UserDefaults.standard.string(forKey: "apiToken") else {
            callback("ログインが必要です", nil)
            return
        }
        
        let url = apiRoot + "/api/posts?api_token=" + apiToken
        
        let request = Alamofire.request(url)
        
        request.responseData { responseData in
            
            if responseData.result.isFailure {
                callback("ネットワークエラー", nil)
                return
                
            }
            
            guard let statusCode = responseData.response?.statusCode else {
                return
            }
            
            if statusCode != 200 {
                callback("エラー", nil)
                return
            }
            
            guard let data = responseData.result.value else {
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                print("decode is done")
                callback(nil, posts)
            } catch {
                print(error)
            }
            
        }
        
    }
    
    static func like(postId: Int, callback: @escaping((String?) -> Void)) {
        
        print("like function called")
        guard let apiToken = UserDefaults.standard.string(forKey: "apiToken") else {
            callback("ログインが必要です")
            return
        }
        
        let url = apiRoot + "/api/posts/\(postId)/likes?api_token=" + apiToken
        
        let request = Alamofire.request(url, method: .post)
        
        request.responseJSON { responseData in
            
            if responseData.result.isFailure {
                
                print("エラー \(String(describing: responseData.error))")
                callback("エラーが発生しました")
                return
                
            }
            
            guard let statusCode = responseData.response?.statusCode else {
                return
            }
            
            guard let data = responseData.result.value as? [String : Any] else {
                return
            }
            
            if statusCode != 200 {
                
                if let message = data["message"] as? String {
                    callback(message)
                }
                return
            }
        
        }
        
        callback(nil)
        
    }
    
    static func unlike(postId: Int, callback: @escaping((String?) -> Void)) {
        
        print("unlike function called")
        guard let apiToken = UserDefaults.standard.string(forKey: "apiToken") else {
            callback("ログインが必要です")
            return
        }
        
        let url = apiRoot + "/api/posts/\(postId)/likes?api_token=" + apiToken
        
        let request = Alamofire.request(url, method: .delete)
        
        request.responseJSON { responseData in
            
            if responseData.result.isFailure {
                
                print("エラー \(String(describing: responseData.error))")
                callback("エラーが発生しました")
                return
                
            }
            
            guard let statusCode = responseData.response?.statusCode else {
                return
            }
            
            guard let data = responseData.result.value as? [String : Any] else {
                return
            }
            
            if statusCode != 200 {
                
                if let message = data["message"] as? String {
                    callback(message)
                }
                return
            }
            
        }
        
        callback(nil)
        
    }
    
    
    
    static func post(image: UIImage, text: String, callback: @escaping((String?) -> Void)) {
        
        guard let apiToken = UserDefaults.standard.string(forKey: "apiToken") else {
            callback("ログインが必要です")
            return
        }
        
        let url = apiRoot + "/api/posts?api_token=" + apiToken
        
        // Alamofireでアップロード
        Alamofire.upload(multipartFormData: { formData in

            // 本文を設定
            formData.append(text.data(using: .utf8, allowLossyConversion: true)!, withName: "body")
            
            // 画像データ
            let jpeg = image.jpegData(compressionQuality: 0.8)!
            formData.append(jpeg, withName: "file", fileName: "image.jpg", mimeType: "image/jpg")
            
        }, to: url) { result in
            
            // 処理結果を扱う
            switch result {
                
            case let .failure(error):
                print(error.localizedDescription)
                callback("サーバーへのアクセス失敗")
            
            case let .success(request, _, _):
                // サーバーからのレスポンスを受け取る
                request.responseJSON { dataResponse in
                
                    if dataResponse.result.isFailure {
                        print(dataResponse.error ?? "")
                        callback("エラー")
                        return
                    }
                
                    if dataResponse.response?.statusCode != 201 {
                        callback("サーバーエラー")
                        return
                    }
                }
            }
        }
    }
    
    static func getComments(postId: Int, callback: @escaping (String?, [Comment]?) -> Void) {
        
        // APIトークンを取得.
        guard let apiToken = UserDefaults.standard.string(forKey: "apiToken") else {
            callback("ログインが必要です", nil)
            return
        }
        
        // URL を作成.
        let url = apiRoot + "/api/posts/\(postId)/comments?api_token=" + apiToken
        
        // API呼び出し.
        Alamofire.request(url).responseData { dataResponse in
            
            // ネットワーク圏外など.
            if dataResponse.result.isFailure {
                print(dataResponse.error ?? "")
                callback("エラーが発生しました。", nil)
                return
            }
            
            // ステータスコードが 200 でない場合、エラー.
            if dataResponse.response?.statusCode != 200 {
                print(dataResponse.result.value ?? "")
                callback("サーバーでエラーが発生しました", nil)
                return
            }
            
            // 成功した場合、サーバーからのレスポンスを受け取る.
            guard let data = dataResponse.result.value else {
                return
            }
            // Commentの配列に変換して、返却する.
            do {
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                callback(nil, comments)
                
            } catch {
                // 変換でエラーが発生した時.
                print(error.localizedDescription)
                callback("エラーが発生しました", nil)
            }
        }
    }
    
    static func addComment(postId: Int, comment: String, callback: @escaping ((String?) -> Void)) {
        
        // APIトークンを取得.
        guard let apiToken = UserDefaults.standard.string(forKey: "apiToken") else {
            callback("ログインが必要です")
            return
        }
        
        // URL作成.
        let url = apiRoot + "/api/posts/\(postId)/comments?api_token=" + apiToken
        
        let params: [String: Any] = [
            "comment" : comment
        ]
        
        // リクエスト作成.
        let request = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
        
        // API実行
        request.responseJSON { dataResponse in
            
            // ネットワーク圏外など.
            if dataResponse.result.isFailure {
                print(dataResponse.error ?? "")
                callback("エラーが発生しました。")
                return
            }
            
            // ステータスコードが 201 でない場合、エラー.
            if dataResponse.response?.statusCode != 201 {
                print(dataResponse.result.value ?? "")
                callback("サーバーでエラーが発生しました")
                return
            }
            
            // 成功.
            callback(nil)
        }
    }

}
