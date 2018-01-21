//
//  PoiTableViewCell.swift
//  Pleyeces
//
//  Created by Filip Aleksić on 20/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import UIKit

class PoiTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
