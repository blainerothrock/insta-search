//
//  SearchResultsTableViewController.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    var searchText:String?
    var isRecent = false
    var media:[Media]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.searchText?.isEmpty ?? true { self.isRecent = true }
        
        setup()
        loadResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.isRecent ? "Recent" : self.searchText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        tableView.separatorStyle = .none
    }
    
    func loadResults() {
        
        if self.isRecent {
            InstagramAPI.shared.getRecentMedia(completion: { (success, media, error) in
                if success, error == nil {
                    self.media = media
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
        } else if let query = self.searchText {
            InstagramAPI.shared.getMedia(for: query, completion: { (success, media, error) in
                if success, error == nil {
                    self.media = media
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return media?.count ?? 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaTableViewCell
        if let m = self.media?[indexPath.row] {
            cell.lblTitle.text = m.user?["username"]
            cell.txtvCaption.text = m.caption?.text
            cell.lblLikeCount.text = "\(m.likes?["count"] ?? 0)"
            if let timeString = m.createdTime, let epochTime = Double(timeString) {
                let date = Date(timeIntervalSince1970: epochTime)
                let dateString = DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .short)
                cell.lblDate.text = "\(dateString)"
            }
            if let imageURL = m.images?.standardRes?.url {
                cell.img.loadImageUsingCache(withUrl: imageURL)
            }
            if let userProfileImageURL = m.user?["profile_picture"] {
                cell.imgUserImage.loadImageUsingCache(withUrl: userProfileImageURL)
            }
        } else {
            // set up mock cell
            cell.lblTitle.text = ""
            cell.txtvCaption.text = ""
            cell.lblLikeCount.text = "0"
            cell.lblDate.text = ""

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.75
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
