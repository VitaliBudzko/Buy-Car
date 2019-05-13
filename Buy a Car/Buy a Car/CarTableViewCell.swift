//
//  CarTableViewCell.swift
//  Buy a Car
//
//  Created by Sasha Dubikovskaya on 03.05.2019.
//  Copyright © 2019 Buy a Car. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var manufactureLabel: UILabel!
    
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var caryearLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
