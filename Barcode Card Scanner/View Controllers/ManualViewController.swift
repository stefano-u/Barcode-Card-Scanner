/*
 Description: This allows the user to manually input the card name/number
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit

class ManualViewController: UIViewController, UITextFieldDelegate {
    // Properties
    @IBOutlet weak var txtCardName: UITextField!  // Text field to input card name
    @IBOutlet weak var txtCardNum: UITextField!   // Text field to input card number
    @IBOutlet weak var lblCardName: UILabel!      // Label to display card name
    @IBOutlet weak var lblCardNum: UILabel!       // Label to display card number
    @IBOutlet weak var btnConvert: UIButton!      // Button to convert the inputs
    @IBOutlet weak var imgView: UIImageView!      // Image view to display the generated barcode
    var newCard = Card()                          // Card object
    var canSubmit : Bool = false                  // Used for testing if the user can submit the card
    var cardNum : String = ""                     // Card number
    var cardName : String = ""                    // Name of card
    var soundEffects = SoundEffect(0)             // Used for playing sound effects
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows for dynamic text colour change whenever the user taps on the buttons
        btnConvert.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        
        // Customizes the apperances of the card num & name labels
        if newCard.getCardOption() == "Best Buy" {
            lblCardNum.textColor = UIColor.black
            lblCardNum.backgroundColor = UIColor.yellow
            lblCardName.textColor = UIColor.black
            lblCardName.backgroundColor = UIColor.yellow
        } else if newCard.getCardOption() == "Cineplex" {
            lblCardNum.textColor = UIColor.yellow
            lblCardNum.backgroundColor = UIColor.blue
            lblCardName.textColor = UIColor.yellow
            lblCardName.backgroundColor = UIColor.blue
        } else if newCard.getCardOption() == "Canadian Tire" {
            lblCardNum.textColor = UIColor.white
            lblCardNum.backgroundColor = UIColor.red
            lblCardName.textColor = UIColor.white
            lblCardName.backgroundColor = UIColor.red
        }
        
        // Adds a TapGestureRecognizer to dismiss the keyboard when the user presses on the background
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ManualViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Disables editing the txtCardName if it is a Custom Card
        if newCard.getCardOption() != "Custom Card" {
            txtCardName.text = newCard.getCardName()
            txtCardName.textColor = UIColor.gray
            txtCardName.isUserInteractionEnabled = false
        } else {
            txtCardName.isUserInteractionEnabled = true
            txtCardName.textColor = UIColor.black
        }
        
        // Adds the submit bar button on the navigation bar
        let submitBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitCard(_:)))
        self.navigationItem.setRightBarButton(submitBarButtonItem, animated: true)
        
        // Initializes sound effect
        soundEffects.setSoundEffect(resourceName: "Error")
    }
    
    // When the "Convert" button is pressed, it will convert the card number into a barcode image
    @IBAction func convertNumToBarcode(_ sender: Any) {
        // Hides the keyboard
        dismissKeyboard()
        
        // Assigns the properties from the correspoding Text Fields
        if let cardNum = txtCardNum.text, let cardName = txtCardName.text  {
            self.cardNum = cardNum
            self.cardName = cardName
        }
        
        // If both TextFields are not empty, then do the conversion
        if !(cardNum.isEmpty) && !(cardName.isEmpty){
            // Converts the card number into a barcode
            let data = cardNum.data(using: .ascii)
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            if let ciImage = filter?.outputImage {
                imgView.image = UIImage(ciImage: ciImage)
                imgView.layer.magnificationFilter = CALayerContentsFilter.nearest
            }
        
            // Updates the labels
            lblCardNum.isHidden = false
            lblCardName.isHidden = false
            lblCardName.text = txtCardName.text
            lblCardNum.text = "Card #: \(txtCardNum.text ?? "")"
            
            // Customizes the appearance of the imgView
            imgView.layer.borderColor = UIColor.gray.cgColor
            imgView.layer.borderWidth = 0.5
            
            // Permits the user to submit the card
            self.canSubmit = true
        } else if cardName.isEmpty && cardNum.isEmpty{
            soundEffects.play()
            showAlert(title: "Multiple Empty Text Fields", message: "Please enter a card name and number.")
        } else if cardName.isEmpty{
            soundEffects.play()
            showAlert(title: "Empty Text Field", message: "Please enter a card name.")
        } else if cardNum.isEmpty{
            soundEffects.play()
            showAlert(title: "Empty Text Field", message: "Please enter a card number.")
        }
    }
    
    // Shows an alert based on the info of the two parameter variables & plays sound effect
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // Submits the card when the user presses Submit bar button and segues to HomeViewController
    @objc func submitCard(_ sender:UIBarButtonItem){
        if canSubmit {
            // Creates new Card object based on user input
            self.newCard.setCardName(name: cardName)
            self.newCard.setCardNum(num: cardNum)
            
            // Boolean expression to compare that the new object's values match the ones in the text fields
            guard let txtCardNumStr = txtCardNum.text, let txtCardNameStr = txtCardName.text else {
                return
            }
            let isSameValue = (cardNum == txtCardNumStr) && (cardName == txtCardNameStr)
            if isSameValue{
                self.navigationController?.popToRootViewController(animated: true)
                showAlert(title: "Success", message: "The card has been added successfully!")
            } else {
                soundEffects.play()
                showAlert(title: "Text Fields Changed", message: "Please convert after changing the text fields.")
            }
        } else {
            // Plays an Error sound effect if the user is unable to submit
            soundEffects.play()
            showAlert(title: "Not Converted", message: "Please convert before submitting.")
        }
    }
    
    // Returns the keyboard once the user presses "Return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // When the tap is recognized, dismiss the keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
