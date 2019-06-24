/*
 Description: Displays all deals based on the specific cards available
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit

class DealViewController: UITableViewController {
    // Properties
    @IBOutlet var tblDeals: UITableView!  // Displays the list of deals
    var cardArray = NSMutableArray()      // Array of Cards
    var dealsList = [Deal]()              // Array of Deals
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Goes through the Array of Cards and checks if certain non-custom cards exist
        for index in 0..<cardArray.count {
            if let card = cardArray.object(at: index) as? Card {
                let cardOption = card.getCardOption()
                if cardOption == "Cineplex" && !dealsList.contains(where: {$0.getDealName() == "Cineplex" }){
                    let cineplexDeal = Deal(dealName: "Cineplex")
                    dealsList.append(cineplexDeal)
                } else if cardOption == "Best Buy" && !dealsList.contains(where: {$0.getDealName() == "Best Buy"}){
                    let bestBuyDeal = Deal(dealName: "Best Buy")
                    dealsList.append(bestBuyDeal)
                } else if cardOption == "Canadian Tire" && !dealsList.contains(where: {$0.getDealName() == "Canadian Tire"}){
                    let canadianTireDeal = Deal(dealName: "Canadian Tire")
                    dealsList.append(canadianTireDeal)
                }
            }
        }
        
        // If none of the non-custom cards exist, then display an alert
        if dealsList.count == 0 {
            let message = "None of your cards have any deals"
            let alert = UIAlertController(title: "No Deals", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    // Sets the number of rows displayed on the TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealsList.count
    }
    
    // Sets the height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    // Sets the appearance of each cell in the TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creates an DealCell object, instead of a regular cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell", for: indexPath) as? DealCell else {
            return UITableViewCell()
        }
        
        // Displays the properties of the Deal object onto the cell
        let index = indexPath.row
        cell.setDealName(dealName: dealsList[index].getDealName())
        cell.setImg(choice: dealsList[index].getDealName())
        return cell
    }
    
    // Before doing a segue, the Card & SoundEffects objects are passed on to the TabBarController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDealWebsite" {
            
            // Retrieves the cell that was selected
            guard let indexPath = tblDeals.indexPathForSelectedRow else {
                return
            }
            let cell = tblDeals.cellForRow(at: indexPath)
            
            // Changes the background colour of the cell to gray
            cell?.backgroundColor = UIColor.gray
            
            // Passes the array of Deals to the DealWebsiteViewController
            if let vc = segue.destination as? DealWebsiteViewController {
                vc.website = dealsList[indexPath.row].getDealWebsite()
            }
            
            // Changes the background colour of the cell back to white
            cell?.backgroundColor = UIColor.white
        }
    }
}
