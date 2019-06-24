/*
 Description: This displays the card's information, as well as additional notes
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit

class SelectedDetailsViewController: UIViewController, UITextViewDelegate {
    // Properties
    @IBOutlet weak var lblCardName: UILabel!     // Displays the name of the card
    @IBOutlet weak var lblCardNum: UILabel!      // Displays the number of the card
    @IBOutlet weak var imgBarcode: UIImageView!  // Displays the barcode iamge
    @IBOutlet weak var cardDetails: UITextView!  // TextView to show the details
    var cardArray = NSMutableArray()             // Array of Cards
    var selectedCard = Card()                    // Selected card from ViewAllCardsViewController
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customizes the apperances of the card num & name labels
        if selectedCard.getCardOption() == "Best Buy" {
            lblCardNum.textColor = UIColor.black
            lblCardNum.backgroundColor = UIColor.yellow
            lblCardName.textColor = UIColor.black
            lblCardName.backgroundColor = UIColor.yellow
        } else if selectedCard.getCardOption() == "Cineplex" {
            lblCardNum.textColor = UIColor.yellow
            lblCardNum.backgroundColor = UIColor.blue
            lblCardName.textColor = UIColor.yellow
            lblCardName.backgroundColor = UIColor.blue
        } else if selectedCard.getCardOption() == "Canadian Tire" {
            lblCardNum.textColor = UIColor.white
            lblCardNum.backgroundColor = UIColor.red
            lblCardName.textColor = UIColor.white
            lblCardName.backgroundColor = UIColor.red
        }
        
        // Adds a TapGestureRecognizer to dismiss the keyboard when the user presses on the background
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectedDetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Customizes the appearance of the imgBarcode
        imgBarcode.layer.borderColor = UIColor.gray.cgColor
        imgBarcode.layer.borderWidth = 0.5
        
        // Calls Text View's delegate to return to user after finish typing on keyboard
        cardDetails.delegate = self
        
        // Converts barcode number to an barcode image
        let cardNumToConvert = selectedCard.getCardNum()
        let data = cardNumToConvert.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        if let ciImage = filter?.outputImage {
            imgBarcode.image = UIImage(ciImage: ciImage)
            imgBarcode.layer.magnificationFilter = CALayerContentsFilter.nearest
        }
        // Sets the card name
        lblCardName.text = selectedCard.getCardName()
        
        // Sets the card number
        lblCardNum.text = "Card #: \(selectedCard.getCardNum())"
        
        // Put card details
        cardDetails.text = selectedCard.getDetails()
        
        // Changes text color to black or grey depending on the contents of the details
        if cardDetails.text == "Add notes here."{
            cardDetails.textColor = UIColor.lightGray
        }
        else{
            cardDetails.textColor = UIColor.black
        }
        
        // Customizes the appearance of the UITextView
        cardDetails.layer.borderColor = UIColor.gray.cgColor
        cardDetails.layer.borderWidth = 0.5
    }
    
    // Used to change text color when user starts to type on text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // Used to save contents of text view
    func textViewDidEndEditing(_ textView: UITextView) {
        if cardDetails.text != "Add notes here." || !cardDetails.text.isEmpty {
            self.selectedCard.setDetails(string: cardDetails.text)
        }
        
        if cardDetails.text.isEmpty || cardDetails.text == ""{
            cardDetails.text = "Add notes here."
            cardDetails.textColor = UIColor.lightGray
            self.selectedCard.setDetails(string: cardDetails.text)
        }
    }
    
    // Makes keyboard dissapear when user hits return on keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // When the tap is recognized, dismiss the keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
