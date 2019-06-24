/*
 Description: This controls the tab bar view controllers by adding a "Remove" function to remove cards
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit

class TabBarController: UITabBarController {
    // Properties
    var selectedCard = Card()         // Card that was selected from the ViewAllCardsViewController
    var cardArray = NSMutableArray()  // Array of Cards
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds the remove bar button on the navigation bar
        let removeBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeCardButton(_:)))
        self.navigationItem.setRightBarButton(removeBarButtonItem, animated: true)
        
        // Passes the array of cards and selected card onto the following ViewControllers
        if let vc = self.viewControllers?[0] as? SelectedCardViewController {
            vc.cardArray = cardArray
            vc.selectedCard = selectedCard
        }
        if let vc = self.viewControllers?[1] as? SelectedDetailsViewController {
            vc.cardArray = cardArray
            vc.selectedCard = selectedCard
        }
    }
    
    // Removes selected card when the "Remove" bar button is pressed
    @objc func removeCardButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Remove Card", message: "Are you sure you want to remove the card?", preferredStyle: .alert)
        
        // If user selects yes, remove the card from the array + database, and reset the selectedCard variable from AppDelegate
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alertAction:UIAlertAction) in
            self.cardArray.remove(self.selectedCard)
            self.navigationController?.popViewController(animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        present(alert, animated: true)
    }
}
