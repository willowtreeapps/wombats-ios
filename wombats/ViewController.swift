//
//  ViewController.swift
//  wombats
//
//  Created by Samuel Shiffman on 7/24/16.
//  Copyright © 2016 Sam Shiffman. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = Bundle.main().urlForResource("payload", withExtension: "txt")!
        
//        let file = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        let data = try! Data(contentsOf: url)
        // Do any additional setup after loading the view, typically from a nib.
        
        let jsonDict = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        let frames = jsonDict["frames"] as! NSArray
        for frame in frames {
            let fr = try! Frame.decodeJSON(json: frame)
            print(fr)
        }
        
        
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

