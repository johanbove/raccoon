//
//  ViewController.swift
//  raccoon
//
//  Created by Oksana Chuiko on 9/10/16.
//  Copyright © 2016 Oksana Chuiko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url_to_request = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=eb77159345d46fd8d77426efc7256d2f76b8640b&url=https://github.com/watson-developer-cloud/doc-tutorial-downloads/raw/master/visual-recognition/fruitbowl.jpg&version=2016-05-19"

    @IBAction func run(sender: AnyObject) {

        let url:NSURL = NSURL(string: url_to_request)!
        let session = NSURLSession.sharedSession()

        let request = NSMutableURLRequest(URL: url)
        print(request)
        request.HTTPMethod = "GET"

        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in

            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }

            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)

        }

        task.resume()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

