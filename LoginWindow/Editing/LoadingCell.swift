//
//  LoadingCell.swift
//  LoginWindow
//
//  Created by 12dot on 20.05.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit
import TinyConstraints


class LoadingCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.centerInSuperview()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
