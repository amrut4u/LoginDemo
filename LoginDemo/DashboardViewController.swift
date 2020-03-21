//
//  DashboardViewController.swift
//  LoginDemo
//
//  Created by Apple on 21/03/20.
//  Copyright © 2020 Amrut Waghmare. All rights reserved.
//

import UIKit
import WebKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    var token:String?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.loadURL()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "Token")
        self.navigationController?.popViewController(animated: true)
    }
    func loadURL(){
        self.activityIndicator.startAnimating()
        let url = URL(string: "https://mckinleyrice.com/?token=\(token ?? "")*")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

//MARK:- WKNavigation Delegate

extension DashboardViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }
}
