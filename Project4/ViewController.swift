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
    var progressView: UIProgressView!
    
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func initToolbar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: webView,
            action: #selector(webView.reload)
        )
        
        toolbarItems = [progressButton, spacer, refreshButton]
        navigationController?.isToolbarHidden = false
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
        initToolbar()
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func showBlockedNavigationAlert() {
        let alert = UIAlertController(
            title: "Blocked",
            message: "The url is blocked",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "Continue", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let host = navigationAction.request.url?.host else {
            showBlockedNavigationAlert()
            decisionHandler(.allow)
            return
        }
        
        let isPageExist = pages.contains(where: { page in
            host.contains( URL(string: page.link)!.host!)
        })
        
        if isPageExist {
            decisionHandler(.allow)
            return
        }
        
        showBlockedNavigationAlert()
        decisionHandler(.cancel)
    }
}

