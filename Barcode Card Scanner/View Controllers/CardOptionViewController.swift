/*
 Description: This will allow the user to select a predefined or custom card to add
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit

class CardOptionViewController: UITableViewController{
    // Properties
    @IBOutlet var tblOptions: UITableView!   // TableView to display the card options
    var soundEffects = SoundEffect(0)        // SoundEffect object
    var newCard = Card()                     // Card object
    var cardOptions =                        // Array of card options
        ["Custom Card", "Cineplex", "Best Buy", "Canadian Tire"]
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Sets the number of rows displayed on the TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardOptions.count
    }
    
    // Sets the height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creates an CardOptionCell object, instead of a regular cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardOptionCell", for: indexPath) as? CardOptionCell else {
            return UITableViewCell()
        }
        
        // Display card options in the table view
        let index = indexPath.row
        cell.setCardName(cardName: cardOptions[index])
        cell.setImg(choice: cardOptions[index])
        return cell
    }
    
    // Before doing a segue, the Card & SoundEffects objects are passed on to the CardMethodViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToCardMethod" {
            
            // Retrieves the cell that was selected
            guard let indexPath = tblOptions.indexPathForSelectedRow else {
                return
            }
            let cell = tblOptions.cellForRow(at: indexPath)
            
            // Changes the background colour of the cell to gray
            cell?.backgroundColor = UIColor.gray
            
            // Updates the card option of the Card object and passes it to the next ViewController
            if let vc = segue.destination as? CardMethodViewController {
                self.newCard.setCardOption(option: cardOptions[indexPath.row])
                vc.newCard = self.newCard
                vc.soundEffects =  self.soundEffects
            }
            
            // Changes the background colour of the cell back to white
            cell?.backgroundColor = UIColor.white
        }
    }
}
