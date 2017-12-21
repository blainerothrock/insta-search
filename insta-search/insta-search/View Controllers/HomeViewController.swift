//
//  ViewController.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/16/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import UIKit
import SafariServices

enum HomeViewSegue:String {
    case recent = "recentSegue"
    case searchResult = "searchResultsSegue"
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var btnAuth: UIButton!
    @IBOutlet weak var lblTagSeach: UILabel!
    @IBOutlet weak var txtfSearchBar: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblSubheader: UILabel!
    @IBOutlet weak var searchView: UIView!
    
    var authSession:SFAuthenticationSession?
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if InstagramAPI.shared.isLoggedIn() {
            self.user = InstagramAPI.shared.currentUser
        }
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        self.txtfSearchBar.delegate = self
        
        if let u = self.user {
            if let firstName = u.fullName?.split(separator: " ").first {
                    self.lblWelcome.text = "Welcome, \(firstName)"
            }
            self.btnAuth.setTitle("Logout", for: .normal)
            self.btnAuth.backgroundColor = UIColor.john
            
            self.searchView.isHidden = false
            
            self.lblSubheader.text = u.username
        } else {
            self.lblWelcome.text = "Welcome"
            self.btnAuth.setTitle("Login", for: .normal)
            self.btnAuth.backgroundColor = UIColor.lightPink
            
            self.searchView.isHidden = true
            
            self.lblSubheader.text = "Please Login to Search"
        }
    }
    
    @IBAction func loginTouched(_ sender: UIButton) {
        if self.user == nil {
            self.authSession = InstagramAPI.shared.getAuthSession() { (success, error) in
                guard success else {
                    print("AUTH ERROR")
                    return
                }
                self.user = InstagramAPI.shared.currentUser
                DispatchQueue.main.async {
                    self.setup()
                }
            }
            self.authSession?.start()
        } else {
            self.user = nil
            InstagramAPI.shared.logout()
            self.setup()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? SearchResultsTableViewController {
            if segue.identifier == HomeViewSegue.recent.rawValue {
                dvc.isRecent = true
            } else if segue.identifier == HomeViewSegue.searchResult.rawValue {
              dvc.searchText = self.txtfSearchBar.text
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty ?? true) {
            self.performSegue(withIdentifier: HomeViewSegue.searchResult.rawValue, sender: nil)
        }
        return true
    }
    
}
