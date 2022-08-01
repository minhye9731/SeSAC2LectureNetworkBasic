//
//  WebViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/28/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String = "https://www.apple.com"
    // App Transport Security Settings
    // http X
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openWebPage(url : destinationURL)
        searchBar.delegate = self
        
    }
    

    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
   

}


extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }

}



