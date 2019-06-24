/*
 Description: This is used to customize the TableViewCell in the CardOptionTableView
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit

class CardOptionCell: UITableViewCell {
    // Properties
    @IBOutlet private weak var lblCardName: UILabel!   // Displays the name of the card
    @IBOutlet private weak var imgCard: UIImageView!   // Displays the image of the card
    
    // Sets the name of the card
    func setCardName(cardName: String) {
        lblCardName.text = cardName
    }
    
    // Sets the image of the card
    func setImg(choice: String) {
        if choice == "Best Buy" {
            imgCard.image = UIImage(named: "Best Buy")
        } else if choice == "Cineplex" {
            imgCard.image = UIImage(named: "Cineplex")
        } else if choice == "Canadian Tire" {
            imgCard.image = UIImage(named: "Canadian Tire")
        } else {
            imgCard.image = UIImage(named: "CustomCard")
        }
    }
}
