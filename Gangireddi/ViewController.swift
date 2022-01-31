//
//  ViewController.swift
//  Gangireddi
//
//  Created by Sandeep on 31/01/22.
//

import UIKit

class ViewController: UIViewController {

    let urls = [
        URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/currentLocation/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/DispatchQueue/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/dynamicFont/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/telegrammy/archive/master.zip")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        

        // call multiple urlsession downloadtask, these will all run at the same time!
        for url in urls {
            print("start fetching \(url.absoluteString)")
            URLSession.shared.downloadTask(with: url, completionHandler: { (tempURL, response, error) in
                print("finished fetching \(url.absoluteString)")
            }).resume()
        }
        
        // Do any additional setup after loading the view.
    }


}

