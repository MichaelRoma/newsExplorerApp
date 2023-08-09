//
//  TimePeriodViewController.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/9.
//

import UIKit

final class TimePeriodViewController: UIViewController {
    private let fromDatePicker = UIDatePicker()
    private let toDatePicker = UIDatePicker()
    var completionHandler: (((to: String, from: String)) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Time Period"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(doneButtonTapped))
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        fromDatePicker.datePickerMode = .date
        fromDatePicker.preferredDatePickerStyle = .wheels
        fromDatePicker.translatesAutoresizingMaskIntoConstraints = false
        fromDatePicker.maximumDate = oneDayAgo
        fromDatePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
     
        toDatePicker.datePickerMode = .date
        toDatePicker.preferredDatePickerStyle = .wheels
        toDatePicker.translatesAutoresizingMaskIntoConstraints = false
        toDatePicker.maximumDate = oneDayAgo
        toDatePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textAlignment = .center
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [fromLabel,fromDatePicker, toLabel,toDatePicker])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
      
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func doneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDate = dateFormatter.string(from: fromDatePicker.date)
        let toDate = dateFormatter.string(from: toDatePicker.date)
        completionHandler?((toDate, fromDate))
        navigationController?.popViewController(animated: true)
    }
}
