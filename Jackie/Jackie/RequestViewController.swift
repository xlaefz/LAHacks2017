//
//  RequestViewController.swift
//  Jackie
//
//  Created by Yuna Lee on 4/1/17.
//  Copyright © 2017 Jackie. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {
    
    @IBOutlet weak var productTypePicker: UIPickerView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var productTypes = ["Only Pads", "Only Tampons", "Either"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
