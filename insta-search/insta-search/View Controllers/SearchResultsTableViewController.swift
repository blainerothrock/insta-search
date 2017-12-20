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
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(self.loadResults), for: .valueChanged)
        tableView.addSubview(self.refreshControl!)
        
    }
    
    @objc func loadResults() {
        
        if self.isRecent {
            InstagramAPI.shared.getRecentMedia(completion: { (success, media, error) in
                if success, error == nil {
                    self.media = media
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
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
                        self.refreshControl?.endRefreshing()
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
            
            cell.videoView.isHidden = true
            cell.img.isHidden = false
            cell.videoView.stop()
            if m.type == "image" {
                if let imageURL = m.images?.standardRes?.url {
                    cell.img.loadImageUsingCache(withUrl: imageURL)
                }
            } else if m.type == "video" {
                if let videoURL = m.videos?.standardRes?.url {
                    cell.videoView.configure(url: videoURL)
                    cell.img.isHidden = true
                    cell.videoView.isHidden = false
                    cell.videoView.play()
                }
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

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        super.scrollViewDidScroll(scrollView)
        if scrollView == self.tableView {
            for indexPath in self.tableView.indexPathsForVisibleRows as! [NSIndexPath] {
                
            }
        }
    }
    
    func setCellImageOffset(cell:MediaTableViewCell, indexPath: NSIndexPath) {
        let cellFrame = self.tableView.rectForRow(at: indexPath as IndexPath)
        let cellFrameInTable = self.tableView.convert(cellFrame, to: self.tableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        var tableHeight = self.tableView.bounds.size.height + cellFrameInTable.size.height
        var cellOffetFactor = cellOffset/tableHeight
//        cell.img.imagecen
        
    }
    
}
