//
//  WeightsViewController.swift
//  Materniteam
//
//  Created by Gustavo Serra on 13/07/2017.
//  Copyright © 2017 Gustavo Serra. All rights reserved.
//

import UIKit

class WeightsViewController: UIViewController {

    @IBOutlet weak var weightTableView: UITableView!
    
    var groupedSortedWeights: Array<Any> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let weights: [Dictionary<String,Any>] = UserDefaults.standard.value(forKey: "WEIGHTS") as? [Dictionary<String,Any>]
        else { return }
        
        var groupedWeights: [Date:[Dictionary<String,Any>]] = [:]
        
        for weight in weights.reversed() {
            
            if let measureDate = weight["measured_at"] as? String {
                
                let measureDateComponents = measureDate.components(separatedBy: " ")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let dateFormatted = dateFormatter.date(from: measureDateComponents[0]) {
                    if case nil = groupedWeights[dateFormatted]?.append(weight) {
                        
                        groupedWeights[dateFormatted] = [weight]
                    }
                }
            }
        }
        
        self.groupedSortedWeights = groupedWeights.sorted(by: { $0.key.compare($1.key) == .orderedDescending })
    }
    
    @IBAction func exitButtonClicked(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "CallerViewController")
        
        UIApplication.shared.keyWindow?.rootViewController = mainViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
}

extension WeightsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.groupedSortedWeights.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sectionDateWeights = self.groupedSortedWeights[section] as? (Date, Any),
            let sectionWeights = sectionDateWeights.1 as? [Dictionary<String,Any>] {
            
            return sectionWeights.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sectionDateWeights = self.groupedSortedWeights[section] as? (Date, Any) {
            
            let measureDate = sectionDateWeights.0
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            
            return dateFormatter.string(from: measureDate)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell", for: indexPath)
        
        if  let sectionDateWeights = self.groupedSortedWeights[indexPath.section] as? (Date, Any),
            let sectionWeights = sectionDateWeights.1 as? [Dictionary<String,Any>],
            let measureDate = sectionWeights[indexPath.row]["measured_at"] as? String,
            let measureWeight = sectionWeights[indexPath.row]["weight"] as? String {
            
            cell.textLabel?.text = measureWeight
            
            let measureDateComponents = measureDate.components(separatedBy: " ")[1]
            let measureTimeComponents = measureDateComponents.components(separatedBy: ":")
            
            cell.detailTextLabel?.text = String("\(measureTimeComponents[0]):\(measureTimeComponents[1])")
        }
   
        return cell
    }
}
