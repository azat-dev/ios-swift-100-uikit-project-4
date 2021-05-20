//
//  TableViewController.swift
//  Project4
//
//  Created by Azat Kaiumov on 20.05.2021.
//

import UIKit


struct PageInfo {
    let title: String
    let link: String
    let allowed: String
}

let pages: [PageInfo] = [
    .init(
        title: "google.com",
        link: "https://google.com",
        allowed: "google\\."
    ),
    .init(
        title: "apple.com",
        link: "https://apple.com",
        allowed: "apple\\."
    ),
    .init(
        title: "hackingwithswift.com",
        link: "https://hackingwithswift.com",
        allowed: "hackingwithswift\\."
    ),
]

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowIndex = indexPath.row
        let page = pages[rowIndex]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Page", for: indexPath)
        cell.textLabel?.text = page.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowIndex = indexPath.row
        let pageViewController = WebPageViewController()
        pageViewController.page = pages[rowIndex]
        
        navigationController?.pushViewController(pageViewController, animated: true)
    }
}
