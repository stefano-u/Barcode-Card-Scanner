/*
 Description: This allows the user to add the card using either manual input or their device's camera
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit

class CardMethodViewController: UIViewController {
    // Properties
    @IBOutlet weak var btnManual: UIButton!    // "Manually Enter" button
    @IBOutlet weak var btnCamera: UIButton!    // "Use Camera" button
    @IBOutlet weak var lblQuestion: UILabel!   // Label to show the prompt
    var soundEffects = SoundEffect(0)          // SoundEffect object
    var newCard = Card()                       // Card object
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows for dynamic text colour change whenever the user taps on the buttons
        btnManual.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnCamera.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        
        // Updates the label based on the selected option in the CardOptionViewController
        if newCard.getCardOption() != "Custom Card" {
            lblQuestion.text = "How would you like to add the \(newCard.getCardOption()) card?"
        } else {
            lblQuestion.text = "How would you like to add the new custom card?"
        }
    }
    
    // Before doing a segue, the Card & SoundEffects objects are passed on to the next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToManual" {
            if let vc = segue.destination as? ManualViewController {
                vc.newCard = self.newCard
                vc.soundEffects = self.soundEffects
            }
        } else if segue.identifier == "SegueToCamera" {
            if let vc = segue.destination as? CameraViewController {
                vc.newCard = self.newCard
                vc.soundEffects = self.soundEffects
            }
        }
    }
}
