//
//  AboutViewController.swift
//  Text Recognition Currency Exchange
//
//  Created by 王传正 on 2018/2/13.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {

}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var updateActivityIndicator: UIActivityIndicatorView!
    
    private let currency = Currency()
    
    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        currency.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Update Exchange Rate
            tableView.deselectRow(at: indexPath, animated: true)
            currency.update()
            //tableView.footerView(forSection: 0)?.textLabel?.text = "Exchange rate information from Fixer. Last updated on YYYY-MM-DD."
        }
    }
    
    private func showUpdateErrorAlert() {
        let alert = UIAlertController(
            title: "Update Failed",
            message: "Failed to fetch latest exchange rates. Please check your internet connection and try again.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController: CurrencyDelegate {
    
    func startActivityIndicator() {
        updateActivityIndicator.startAnimating()
    }
    func stopActivityIndicator() {
        updateActivityIndicator.stopAnimating()
    }
    
    func setRefreshDateText() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: currency.refreshDate!)
        let newFooterText = "Exchange rate information from Fixer. Last updated on \(dateString)"
        tableView.footerView(forSection: 0)?.textLabel?.text = newFooterText
    }
    
}
