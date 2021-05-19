//
//  ViewController.swift
//  Project4
//
//  Created by Azat Kaiumov on 19.05.2021.
//

import UIKit
import WebKit

struct PageInfo {
    let title: String
    let link: String
}

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    let pages: [PageInfo] = [
        .init(title: "google.com", link: "https://google.com"),
        .init(title: "apple.com", link: "https://apple.com"),
        .init(title: "hackingwithswift.com", link: "https://hackingwithswift.com"),
    ]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func initWebView() {
        let url = URL(string: "https://google.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func initNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openButtonTapped)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWebView()
        initNavigationBar()
    }
    
    @objc func openButtonTapped() {
        let alert = UIAlertController(
            title: "Open page...",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for page in pages {
            alert.addAction(
                .init(
                    title: page.title,
                    style: .default,
                    handler: openPage
                )
            )
        }
        
        alert.addAction(
            .init(
                title: "Cancel",
                style: .cancel
            )
        )
        
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(alert, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let page = pages.first(where: { $0.title == action.title }) else {
            return
        }
        
        guard let url = URL(string: page.link) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}

