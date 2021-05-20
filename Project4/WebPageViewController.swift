//
//  ViewController.swift
//  Project4
//
//  Created by Azat Kaiumov on 19.05.2021.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController, WKNavigationDelegate {
    var page: PageInfo!
    var webView: WKWebView!
    var progressView: UIProgressView!
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func initWebView() {
        let url = URL(string: page.link)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
        case "estimatedProgress":
            progressView.progress = Float(webView.estimatedProgress)
        case "canGoBack":
            backButton.isEnabled = webView.canGoBack
        case "canGoForward":
            forwardButton.isEnabled = webView.canGoForward
        default:
            return
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
        
        backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            style: .plain,
            target: webView,
            action: #selector(webView.goBack)
        )
        
        backButton.isEnabled = webView.canGoBack
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.canGoBack),
            options: .new,
            context: nil
        )
        
        forwardButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.forward"),
            style: .plain,
            target: webView,
            action: #selector(webView.goForward)
        )
        
        forwardButton.isEnabled = webView.canGoForward
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.canGoForward),
            options: .new,
            context: nil
        )
        
        
        toolbarItems = [progressButton, spacer, backButton, forwardButton, refreshButton]
        navigationController?.isToolbarHidden = false
    }
    
    func initNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
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

