/*
 Description: Displays all cards in the database onto the TableView
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit

class ViewAllCardsViewController: UITableViewController {
    // Properties
    @IBOutlet var tblAllCards: UITableView!  // TableView to show all cards
    var cardArray = NSMutableArray()         // Array of Cards
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmptyArray()
    }
    
    // When this view appears again (ie. after returning from the next view controllers), it will update the TableView
    override func viewDidAppear(_ animated: Bool) {
        tblAllCards.reloadData()
        checkEmptyArray()
    }
    
    // If there are no cards stored in the array, then it will show an alert
    func checkEmptyArray() {
        if cardArray.count == 0 {
            let message = "No cards available to view. Please enter a card first."
            let alert = UIAlertController(title: "Cards Unavailable", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    // Sets the number of rows displayed on the TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    // Sets the height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    // Sets the appearance of each cell in the TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creates an CardCell object, instead of a regular cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardCell else{
            return UITableViewCell()
        }
        
        // Displays the properties of the card onto the cell
        let index = indexPath.row
        if let card = cardArray.object(at: index) as? Card {
            cell.setCardNum(cardNum: card.getCardNum())
            cell.setCardName(cardName: card.getCardName())
            cell.setImg(image: card.getCardOptionImg())
        }
        return cell
    }
    
    // Before doing a segue, the Card & SoundEffects objects are passed on to the TabBarController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToTabBar" {
            
            // Retrieves the cell that was selected
            guard let indexPath = tblAllCards.indexPathForSelectedRow else {
                return
            }
            let cell = tblAllCards.cellForRow(at: indexPath)
            
            // Changes the background colour of the cell to gray
            cell?.backgroundColor = UIColor.gray
            
            // Passes the array of cards & the selected card
            if let vc = segue.destination as? TabBarController {
                if let selectedCard = cardArray.object(at: indexPath.row) as? Card{
                    vc.cardArray = cardArray
                    vc.selectedCard = selectedCard
                }
            }
            
            // Changes the background colour of the cell back to white
            cell?.backgroundColor = UIColor.white
        }
    }
}
