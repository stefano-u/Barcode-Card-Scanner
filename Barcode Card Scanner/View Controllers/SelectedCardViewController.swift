/*
 Description: This displays the card's information, as well as the front/back images
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit

class SelectedCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Properties
    @IBOutlet weak var imgBarcode: UIImageView!  // Displays the barcode
    @IBOutlet weak var imgFront: UIButton!       // Displays the front image of the card
    @IBOutlet weak var imgBack: UIButton!        // Displays the back image of the card
    @IBOutlet weak var lblCardNum: UILabel!      // Displays the number of the card
    @IBOutlet weak var lblCardName: UILabel!     // Displays the name of the card
    var cardArray = NSMutableArray()             // Array of Cards
    var selectedCard = Card()                    // Selected card from ViewAllCardsViewController
    var imageNumber: Int = 0                     // Controls if the user pressed Front or Back Image button
    
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
        
        // Customizes the appearance of the imgBarcode
        imgBarcode.layer.borderColor = UIColor.gray.cgColor
        imgBarcode.layer.borderWidth = 0.5
        
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
        
        // Sets the front & back images of the card
        imgFront.setImage(selectedCard.getFrontImg(), for: .normal)
        imgBack.setImage(selectedCard.getBackImg(), for: .normal)
        
        // Sets the visual appearance of the imgFront and imgBack
        imgFront.layer.borderColor = UIColor.gray.cgColor
        imgFront.layer.borderWidth = 0.5
        imgFront.layer.cornerRadius = 5
        imgBack.layer.borderColor = UIColor.gray.cgColor
        imgBack.layer.borderWidth = 0.5
        imgBack.layer.cornerRadius = 5
    }
    
    // Handles the image to be shown when the Front Image button is pressed
    @IBAction func frontViewPressed(_ sender: Any) {
        imageNumber = 1
        selectPhoto()
    }
    
    // Handles the image to be shown when the Back Image button is pressed
    @IBAction func backViewPressed(_ sender: Any) {
        imageNumber = 2
        selectPhoto()
    }
    
    // Selects a photo using camera or from photo album
    func selectPhoto() {
        // Enables the camera for use
        let camera = CameraHandler(delegate: self)
        
        // Allows the user to either choose to take a photo or choose an existing photo from their library
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        // Option to take a photo
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler:{
            (alert : UIAlertAction) in
            camera.getCameraOn(self, canEdit: true)
        })
        
        // Option to choose a photo from the photo library
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert : UIAlertAction) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // Gets the image from the library/camera and assign it
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // Store chosen image to variable
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage else {
            return
        }
        
        // Switch to each button according to the value of imageNumber
        switch imageNumber {
            case 1:
                selectedCard.setFrontImg(img: image)
                imgFront.setImage(image, for: .normal)
                break;
            case 2:
                selectedCard.setBackImg(img: image)
                imgBack.setImage(image, for: .normal)
                break;
            default:
                break;
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
