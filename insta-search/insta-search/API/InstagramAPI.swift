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

enum InstagramKey: String {
    case baseURL = "Instagram API Base URL"
    case authURL = "Instagram API Auth URL"
    case clientId = "Instagram Client Id"
    case redirectURL = "Instagram Redirect URL"
    case callbackScheme = "Instagram Callback Scheme"
    case scope = "Instagram Scope"
}

class InstagramAPI {
    static var shared = InstagramAPI()
    
    var apiBaseURL:String! = ""
    var authURL:String! = ""
    var clientId:String! = ""
    var redirectURI:String! = ""
    var callbackScheme:String! = ""
    var scope:String! = ""
    
    var token: String?
    var currentUser:User?
    
    init() {
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let resourceFileDictionary = NSDictionary(contentsOfFile: path) as? [String:Any] {
                if let instagram = resourceFileDictionary["Instagram"] as? [String:String] {
                    self.apiBaseURL = instagram[InstagramKey.baseURL.rawValue] ?? ""
                    self.authURL = instagram[InstagramKey.authURL.rawValue] ?? ""
                    self.clientId = instagram[InstagramKey.clientId.rawValue] ?? ""
                    self.redirectURI = instagram[InstagramKey.redirectURL.rawValue] ?? ""
                    self.callbackScheme = instagram[InstagramKey.callbackScheme.rawValue] ?? ""
                    self.scope = instagram[InstagramKey.scope.rawValue] ?? ""
                }
            }
        }
        
        guard !self.apiBaseURL.isEmpty,
            !self.authURL.isEmpty,
            !self.clientId.isEmpty,
            !self.redirectURI.isEmpty,
            !self.callbackScheme.isEmpty,
            !self.scope.isEmpty else {
                fatalError("Config not set")
        }
        
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
        
        let authURLString = "\(self.authURL!)?client_id=\(self.clientId!)&redirect_uri=\(self.redirectURI!)&response_type=code&scope=\(self.scope!)&DEBUG=true"
        let authURL = URL(string: authURLString)
        
        return SFAuthenticationSession(url: authURL!, callbackURLScheme: self.callbackScheme, completionHandler: completionHandler)
    }
    
    private func getUser(callback: @escaping (_ success:Bool, _ error: Error?) -> ()) {
        guard self.token != nil else { return }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlString = "\(self.apiBaseURL!)/users/self/?access_token=\(self.token!)"
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
        
        let urlString = "\(self.apiBaseURL!)/tags/\(tag)/media/recent?access_token=\(self.token!)"
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
        
        let urlString = "\(self.apiBaseURL!)/users/self/media/recent?access_token=\(self.token!)"
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


