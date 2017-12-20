//
//  MediaTableViewCell.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtvCaption: UITextView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUserImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        self.lblTitle.textColor = UIColor.john
        self.lblLikeCount.textColor = UIColor.john
        self.lblDate.textColor = UIColor.john
        self.txtvCaption.backgroundColor = UIColor.white
        self.txtvCaption.isUserInteractionEnabled = false
        self.txtvCaption.textColor = UIColor.lightPink
        self.txtvCaption.textContainer.lineFragmentPadding = 0
        self.txtvCaption.textContainerInset = .zero
        
        self.imgUserImage.clipsToBounds = true
        self.imgUserImage.layer.cornerRadius = 25.0
        self.imgUserImage.layer.borderWidth = 3.0
        self.imgUserImage.layer.borderColor = UIColor.lightPink.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
