/*
 Description: This displays the website of the specific deal chosen in DealViewController
 Author: Michael Marc
 Date: 2018-12-09
 */

import UIKit
import WebKit

class DealWebsiteViewController: UIViewController, WKNavigationDelegate{
    // Properties
    @IBOutlet weak var webView: WKWebView!                          // Web view to display the website
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!  // Activity indicator to show the loading of the website
    var website: String = ""                                        // Website to be shown
    
    // Initializes the view controller when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loads the website onto the WebView
        webView.navigationDelegate = self
        if let url = URL(string: website) {
            webView.load(URLRequest(url: url))
        }
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // Stops the activity indicator when the website has loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    // Starts the activity indicator when the website has started to load
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
}
