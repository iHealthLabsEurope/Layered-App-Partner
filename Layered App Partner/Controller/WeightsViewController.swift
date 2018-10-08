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
    
    var groupedSortedMeasurements: Array<Any> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let measurements: [Dictionary<String,Any>] = UserDefaults.standard.value(forKey: "MEASUREMENTS") as? [Dictionary<String,Any>]
        else { return }
        
        var groupedMeasurements: [Date:[Dictionary<String,Any>]] = [:]
        
        for measurement in measurements.reversed() {
            
            if let measureDate = measurement["measured_at"] as? String {
                
                let measureDateComponents = measureDate.components(separatedBy: " ")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let dateFormatted = dateFormatter.date(from: measureDateComponents[0]) {
                    if case nil = groupedMeasurements[dateFormatted]?.append(measurement) {
                        
                        groupedMeasurements[dateFormatted] = [measurement]
                    }
                }
            }
        }
        
        self.groupedSortedMeasurements = groupedMeasurements.sorted(by: { $0.key.compare($1.key) == .orderedDescending })
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
        
        return self.groupedSortedMeasurements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sectionDateMeasurements = self.groupedSortedMeasurements[section] as? (Date, Any),
            let sectionMeasurements = sectionDateMeasurements.1 as? [Dictionary<String,Any>] {
            
            return sectionMeasurements.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sectionDateMeasurements = self.groupedSortedMeasurements[section] as? (Date, Any) {
            
            let measureDate = sectionDateMeasurements.0
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            
            return dateFormatter.string(from: measureDate)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell", for: indexPath)
        
        if  let sectionDateMeasurements = self.groupedSortedMeasurements[indexPath.section] as? (Date, Any),
            let sectionMeasurement = sectionDateMeasurements.1 as? [Dictionary<String,Any>],
            let measureDate = sectionMeasurement[indexPath.row]["measured_at"] as? String,
            let measureOxygenSaturation = sectionMeasurement[indexPath.row]["oxygen_saturation"] as? String,
            let measureHeartRate = sectionMeasurement[indexPath.row]["heart_rate"] as? String {
            
            cell.textLabel?.text = "\(measureOxygenSaturation)% - \(measureHeartRate)bpm"
            
            let measureDateComponents = measureDate.components(separatedBy: " ")[1]
            let measureTimeComponents = measureDateComponents.components(separatedBy: ":")
            
            cell.detailTextLabel?.text = String("\(measureTimeComponents[0]):\(measureTimeComponents[1])")
        }
   
        return cell
    }
}
