//
//  CurrencyCell.swift
//  Currencies
//
//  Created by George Prokopenko on 28.02.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize(data: NSDictionary!) {
        nameLabel.text = data.object(forKey: "name") as? String
        let volume: Int? = data.value(forKey: "volume") as? Int
        volumeLabel.text = String(describing: volume!)
        let price: NSDictionary? = data.object(forKey: "price") as? NSDictionary
        let amount: CGFloat? = price?.object(forKey: "amount") as? CGFloat
        amountLabel.text = String(format: "%.2f", amount!)
    }

}
