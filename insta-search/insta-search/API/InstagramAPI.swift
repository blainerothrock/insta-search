//
//  Authenication.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/16/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import Foundation
import SafariServices

enum UserDefaultKeys:String {
    case token = "token"
    case user = "user"
}

class InstagramAPI {
    static let apiBaseURL:String = "https://api.instagram.com/v1"
    static let authURL:String = "https://api.instagram.com/oauth/authorize/"
    static let clientId:String = "7b867a5f5a9d4b7486e340e3d95bc8e1"
    static let clientSecret:String = "cddd8808fd054de5a51173035c5ff69c"
    static let redirectURI:String = "http://192.168.86.106:5000/callback"
    static let callbackScheme:String = "instatag://"
    static let scope:String = "public_content"
    
    static var shared = InstagramAPI()
    
    var token: String?
    var currentUser:User?
    
    init() {
        let defaults = UserDefaults.standard
        if let token = defaults.object(forKey: UserDefaultKeys.token.rawValue) as? String {
            self.token = token
        }
        if let userData = defaults.object(forKey: UserDefaultKeys.user.rawValue) as? Data {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: userData)
                self.currentUser = user
            } catch let error {
                print("error retriving user from user defaults: \(error)")
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.object(forKey: UserDefaultKeys.token.rawValue) as? String {
            return true
        }
        return false
    }
    
    func getAuthSession(callback: @escaping (_ success:Bool, _ error: Error?) -> ()) -> SFAuthenticationSession {
        let completionHandler: SFAuthenticationSession.CompletionHandler = { (url, error) in
            guard error == nil, let successURL = url else {
                callback(false, error)
                return
            }
            
            let urlComponents = URLComponents(string: (url?.absoluteString)!)
            let oauthToken = urlComponents?.queryItems?.first(where: { $0.name == "token" })
            self.token = oauthToken!.value!
        
            let defaults = UserDefaults.standard
            defaults.set(self.token!, forKey: "token")
        
            self.getUser(callback: callback)
        }
        
        let authURLString = "\(InstagramAPI.authURL)?client_id=\(InstagramAPI.clientId)&redirect_uri=\(InstagramAPI.redirectURI)&response_type=code&scope=\(InstagramAPI.scope)&DEBUG=true"
        let authURL = URL(string: authURLString)
        
        return SFAuthenticationSession(url: authURL!, callbackURLScheme: InstagramAPI.callbackScheme, completionHandler: completionHandler)
    }
    
    private func getUser(callback: @escaping (_ success:Bool, _ error: Error?) -> ()) {
        guard self.token != nil else { return }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlString = "\(InstagramAPI.apiBaseURL)/users/self/?access_token=\(self.token!)"
        let url = URL(string: urlString)
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if data != nil,
                let res = response as? HTTPURLResponse,
                res.statusCode == 200 {
                
                do {
                    let decoder = JSONDecoder()
                    let user:User? = try decoder.decode(User.self, from: data!)
                    self.currentUser = user
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(data, forKey: "user")
                    
                    callback(true,nil)
                } catch let error {
                    print(error)
                    callback(false,error)
                }
            }
        }
        dataTask.resume()
    }
    
    func getMedia(for tag:String, completion: @escaping (_ success:Bool, _ media: [Media]?, _ error:Error?) -> ()) {
        guard self.token != nil else {
            completion(false, nil, nil)
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlString = "\(InstagramAPI.apiBaseURL)/tags/\(tag)/media/recent?access_token=\(self.token!)"
        let url = URL(string: urlString)!
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(false, nil, error)
            }
            
            if data != nil,
                let res = response as? HTTPURLResponse,
                res.statusCode == 200 {
                
                do {
                    let decoder = JSONDecoder()
                    let mediaResponse = try decoder.decode(MediaResponse.self, from: data!)
                    completion(true, mediaResponse.data, nil)
                } catch let error {
                    completion(false, nil, error)
                }
            }
        }
        dataTask.resume()
    }
    
    func getRecentMedia(completion: @escaping (_ success:Bool, _ media: [Media]?, _ error:Error?) -> ()) {
        guard self.token != nil else {
            completion(false, nil, nil)
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlString = "\(InstagramAPI.apiBaseURL)/users/self/media/recent?access_token=\(self.token!)"
        let url = URL(string: urlString)!
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(false, nil, error)
            }
            
            if data != nil,
                let res = response as? HTTPURLResponse,
                res.statusCode == 200 {
                
                do {
                    let decoder = JSONDecoder()
                    let mediaResponse = try decoder.decode(MediaResponse.self, from: data!)
                    completion(true, mediaResponse.data, nil)
                } catch let error {
                    completion(false, nil, error)
                }
            }
        }
        dataTask.resume()
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserDefaultKeys.token.rawValue)
        defaults.removeObject(forKey: UserDefaultKeys.user.rawValue)
    }
}


