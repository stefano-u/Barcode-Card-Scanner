/*
 Description: This is used to customize the TableViewCell in the DealsTableView
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit

class DealCell: UITableViewCell {
    // Properties
    @IBOutlet private weak var imgDeal: UIImageView!    // Displays the image of the deal
    @IBOutlet private weak var lblDealName: UILabel!    // Displays the name of the deal
    
    // Sets the name of the deal
    func setDealName(dealName: String) {
        lblDealName.text = "\(dealName) Deals"
    }
    
    // Sets the image of the deal
    func setImg(choice: String) {
        if choice == "Best Buy" {
            imgDeal.image = UIImage(named: "Best Buy")
        } else if choice == "Cineplex" {
            imgDeal.image = UIImage(named: "Cineplex")
        } else if choice == "Canadian Tire" {
            imgDeal.image = UIImage(named: "Canadian Tire")
        }
    }
}
