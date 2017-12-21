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
    @IBOutlet weak var imgTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtvCaption: UITextView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet weak var videoView: VideoView!
    
    let imageParallaxFactor:CGFloat = 25
    var imageHeight:CGFloat!
    
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
        
        self.imageHeight = self.img.frame.height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImgOffset(offset:CGPoint) {
        self.img.frame = self.img.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
}
