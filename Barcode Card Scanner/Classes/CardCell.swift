/*
 Description: This is used to customize the TableViewCell in the ViewAllCardsTableView
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit

class CardCell: UITableViewCell {
    // Properties
    @IBOutlet private weak var lblCardName: UILabel!  // Displays the card name
    @IBOutlet private weak var lblCardNum: UILabel!   // Displays the card number
    @IBOutlet private weak var imgCard: UIImageView!  // Displays the image of the card
    
    // Sets the card name on the corresponding label
    func setCardName(cardName: String) {
        lblCardName.text = cardName
    }
    
    // Sets the card number on the corresponding label
    func setCardNum(cardNum: String) {
        lblCardNum.text = "Card #: \(cardNum)"
    }
    
    // Sets the image of the card on the image view
    func setImg(image: UIImage) {
        imgCard.image = image
    }
}
