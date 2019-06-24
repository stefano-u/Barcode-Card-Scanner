/*
 Description: This is the home page where certain objects are originally initialized and passed on to other View Controllers
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit

class HomeViewController: UIViewController{
    // Properties
    @IBOutlet weak var btnAdd: UIButton!        // "Add New Card" button
    @IBOutlet weak var btnViewAll: UIButton!    // "View All Cards" button
    @IBOutlet weak var btnViewDeals: UIButton!  // "View Deals" button
    @IBOutlet weak var btnSettings: UIButton!   // "Settings" button
    var soundEffects = SoundEffect(1)           // Initializes a SoundEffect object with 100% volume
    var cardArray = NSMutableArray()            // Initializes an array of Cards
    var newCard = Card()                        // Initializes an Card object
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Allows for dynamic text colour change whenever the user taps on the buttons
        btnAdd.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnViewAll.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnViewDeals.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnSettings.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
    }
    
    // Before doing a segue, specific objects are passed on to the corresponding View Controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "SegueToCardOption" {
            if let vc = segue.destination as? CardOptionViewController {
                vc.newCard = self.newCard
                vc.soundEffects = self.soundEffects
            }
        } else if segue.identifier == "SegueToViewAllCards" {
            if let vc = segue.destination as? ViewAllCardsViewController {
                vc.cardArray = self.cardArray
            }
        } else if segue.identifier == "SegueToSettings" {
            if let vc = segue.destination as? SettingsViewController {
                vc.cardArray = self.cardArray
                vc.soundEffects = self.soundEffects
            }
        } else if segue.identifier == "SegueToDeals" {
            if let vc = segue.destination as? DealViewController {
                vc.cardArray = self.cardArray
            }
        }
    }
    
    // When this view appears again (ie. after popping to the root view controller), it will update the Card object
    override func viewDidAppear(_ animated: Bool) {
        if !newCard.getCardName().isEmpty && !newCard.getCardNum().isEmpty{
            cardArray.add(newCard)
        }
        newCard = Card()
    }
}

