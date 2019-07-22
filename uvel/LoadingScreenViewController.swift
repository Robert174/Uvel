//
//  LoadingScreenViewController.swift
//  uvel
//
//  Created by Роберт Райсих on 15/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoadingScreenViewController: UIViewController {

    let headers = ["device": "mobile", "x-token": "test_2196", "Content-Type": "application/json" ]
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        getData(url: "https://test.agentx.napoleonit.ru/api/v1/audit/tasks/196186/schema")
        activityIndicator.stopAnimating()
        performSegue(withIdentifier: "goToNextScreen", sender: self)
    }
    
    func getData(url: String) {
        Alamofire.request(url, method: .get, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let result: Response = try! JSONDecoder().decode(Response.self, from: response.data!)
                print(result)
            }
            else {
                print(response.result.error!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNextScreen" {
            let nextVC = segue.destination as! ViewController
        }
    }
}
