/*
 Description: This will allow the user to remove the cards, view the creators, and change the volume of the sound effects
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit
import AVFoundation

class SettingsViewController: UIViewController{
    // Properties
    @IBOutlet weak var lblVolume: UILabel!      // "Volume" label
    @IBOutlet weak var sldVol: UISlider!        // Slider to control volume
    @IBOutlet weak var btnAbout: UIButton!      // "About Us" button
    @IBOutlet weak var btnRemoveAll: UIButton!  // "Remove All Cards" button
    var soundEffects = SoundEffect(0)           // SoundEffect object
    var cardArray = NSMutableArray()            // Array of Cards
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows for dynamic text colour change whenever the user taps on the buttons
        btnAbout.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnRemoveAll.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        
        // Makes the slider to only detect the value at the end of the slider drag
        sldVol.isContinuous = false
        
        // Sets the saved value of the volume
        sldVol.value = soundEffects.getVolume()
        let strVol = String(format : "%d", Int(sldVol.value * 100))
        lblVolume.text = "VOLUME: \(strVol)"
    }
    
    // Displays an alert that show information about the creators of this app
    @IBAction func viewAboutUs(_ sender: Any) {
        let message = "Thanks for using our app! Made by Stefano Gregor Unlayao & Michael Marc"
        let alert = UIAlertController(title: "About Us", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
    
    // Displays an alert that prompts the user if they want to remove all cards from the app
    @IBAction func removeAllCards(_ sender: Any) {
        let message = "Are you sure you want to delete all cards?"
        let alert = UIAlertController(title: "Delete All Cards", message: message, preferredStyle: .alert)
        
        // Removes all card objects within the array (if there are any cards)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            _ in
            if self.cardArray.count != 0 {
                self.cardArray.removeAllObjects()
            } else {
                let message = "There are no cards to delete."
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    // Changes the volume of the sound effects as the slider is moved
    @IBAction func sliderValueChanged(_ sender: Any) {
        let vol = sldVol.value
        let strVol = String(format : "%d", Int(vol * 100))
        lblVolume.text = "VOLUME: \(strVol)"
        
        // As the slider is moved, a sound effect is played with a given volume
        soundEffects.setVolume(volume: vol)
        soundEffects.setSoundEffect(resourceName: "BarcodeFound")
        soundEffects.play()
    }
}
