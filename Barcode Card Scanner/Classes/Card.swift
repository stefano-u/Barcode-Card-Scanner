/*
 Description: This holds information about a Card
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit

class Card: NSObject {
    // Properties
    private var cardName : String         // Name of the card
    private var cardNum : String          // Card number
    private var frontImg : UIImage!       // Front image used for the card
    private var backImg : UIImage!        // Back image used for the card
    private var details : String          // Details/notes used with the card
    private var cardOption: String        // Option of the card
    private var cardOptionImg : UIImage!  // Image for the option
    
    // Initializes an empty card
    override init() {
        self.cardName = ""
        self.cardNum = ""
        self.frontImg = UIImage(named: "DefaultImage")
        self.backImg = UIImage(named: "DefaultImage")
        self.details = "Add notes here."
        self.cardOption = ""
        self.cardOptionImg = UIImage(named: "CustomCard")
    }
    
    // Returns card name
    func getCardName() -> String{
        return cardName
    }
    
    // Returns card number
    func getCardNum() -> String{
        return cardNum
    }
    
    // Returns front picture image
    func getFrontImg() -> UIImage {
        return self.frontImg
    }
    
    // Returns back picture image
    func getBackImg() -> UIImage {
        return self.backImg
    }
    
    // Returns details text
    func getDetails() -> String {
        return self.details
    }
    
    // Returns card option
    func getCardOption() -> String{
        return self.cardOption
    }
    
    // Sets the name of card
    func setCardName(name: String){
        self.cardName = name
    }
    
    // Sets the number of the card
    func setCardNum(num: String){
        self.cardNum = num
    }
    
    // Sets the front image
    func setFrontImg(img: UIImage){
        self.frontImg = img;
    }
    
    // Sets the back image
    func setBackImg(img: UIImage){
        self.backImg = img;
    }
    
    // Sets the details of the card
    func setDetails(string : String){
        self.details = string
    }
    
    // Sets the option of the card based on the option
    func setCardOption(option: String) {
        self.cardOption = option
        
        if self.cardOption != "Custom Card" {
            self.cardName = self.cardOption
            
            if self.cardOption == "Cineplex" {
                self.cardOptionImg = UIImage(named: "Cineplex")
                
            } else if self.cardOption == "Best Buy" {
                self.cardOptionImg = UIImage(named: "Best Buy")
                
            } else if self.cardOption == "Canadian Tire" {
                self.cardOptionImg = UIImage(named: "Canadian Tire")
            }
        } else {
            self.cardName = ""
            self.cardOptionImg = UIImage(named: "CustomCard")
        }
    }
    
    // Returns the UIImage of the card
    func getCardOptionImg() -> UIImage {
        return self.cardOptionImg!
    }
}
