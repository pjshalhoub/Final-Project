//
//  LocationDetailTableViewCell.swift
//  Final
//
//  Created by PJ Shalhoub on 11/23/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//

import UIKit

class LocationDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    
    @IBOutlet weak var oneStarCellImage: UIImageView!
    @IBOutlet weak var twoStarCellImage: UIImageView!
    @IBOutlet weak var threeStarCellImage: UIImageView!
    @IBOutlet weak var fourStarCellImage: UIImageView!
    @IBOutlet weak var fiveStarCellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
   /*
    func update(with location: SportsDetail) {
        stadiumNameLabel.text = location.location
        postedByLabel.text = location.postedBy
    }
*/

}
