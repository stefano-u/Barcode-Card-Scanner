/*
 Description: This holds information of a specific deal
 Author: Michael Marc
 Date: 2018-12-09
 */

import Foundation

struct Deal {
    // Properties
    private var dealName: String      // Name of the deal
    private var dealWebsite: String   // URL of the specific deal
    
    // Initializes the deal's website based on its name
    init(dealName: String) {
        self.dealName = dealName
        self.dealWebsite = ""
        if dealName == "Best Buy" {
            dealWebsite = "http://m.bestbuy.ca/en-CA/collection/shop-all-deals/16074?icmp=mdot_link_topdeals"
        } else if dealName == "Canadian Tire" {
            dealWebsite = "https://www.canadiantire.ca/content/canadian-tire/en/hot-deals/all-deals.html?adlocation=ST_AllDeals_HOS_en"
        } else if dealName == "Cineplex" {
            dealWebsite = "https://store.cineplex.com/default"
        }
    }
    
    // Returns the name of the deal
    func getDealName() -> String {
        return self.dealName
    }
    
    // Returns the website of the deal
    func getDealWebsite() -> String {
        return self.dealWebsite
    }
    
}
