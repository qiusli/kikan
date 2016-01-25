//
//  ContextMenuCell.swift
//  Kikan
//
//  Created by Qiushi Li on 1/24/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit

class ContextMenuCell: UITableViewCell, YALContextMenuCell {
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    func animatedIcon() -> UIView! {
        return menuImageView
    }
    
    func animatedContent() -> UIView! {
        return menuTitleLabel
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = UITableViewCellSelectionStyle.None
        layer.masksToBounds = true
        layer.shadowOffset = CGSizeMake(0, 2)
        layer.shadowColor = UIColor(red: 181.0/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1.0).CGColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
