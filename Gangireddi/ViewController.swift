//
//  ViewController.swift
//  Gangireddi
//
//  Created by Sandeep on 31/01/22.
//

import UIKit

class ViewController: UIViewController,URLSessionDownloadDelegate {
    
    let urls = [
        URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/currentLocation/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/DispatchQueue/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/dynamicFont/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/telegrammy/archive/master.zip")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url: URL = URL(string: "https://ars.els-cdn.com/content/image/1-s2.0-S1525001616328027-mmc2.pdf") else {
            return
        }
        let downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        
        // call multiple urlsession downloadtask, these will all run at the same time!
//        for url in urls {
//            let configuration = URLSessionConfiguration.default
//            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
//
//            let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: url) { (tempURL, response, error) in
//                print("finished downloading \(url.absoluteString)")
//            }
//            operationQueue.addOperation(operation)
//
//        }
        
        // Do any additional setup after loading the view.
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\(totalBytesWritten)")
        print("\(totalBytesExpectedToWrite)")
    }
}


class DownloadOperation : Operation {
    
    private var task : URLSessionDownloadTask!
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    // default state is ready (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    init(session: URLSession, downloadTaskURL: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) {
        super.init()
        
        // use weak self to prevent retain cycle
        task = session.downloadTask(with: downloadTaskURL, completionHandler: { [weak self] (localURL, response, error) in
            
            /*
             if there is a custom completionHandler defined,
             pass the result gotten in downloadTask's completionHandler to the
             custom completionHandler
             */
            if let completionHandler = completionHandler {
                // localURL is the temporary URL the downloaded file is located
                completionHandler(localURL, response, error)
            }
            
            /*
             set the operation state to finished once
             the download task is completed or have error
             */
            self?.state = .finished
        })
    
    }
    
    override func start() {
        /*
         if the operation or queue got cancelled even
         before the operation has started, set the
         operation state to finished and return
         */
        if(self.isCancelled) {
            state = .finished
            return
        }
        
        // set the state to executing
        state = .executing
        
        print("downloading \(self.task.originalRequest?.url?.absoluteString ?? "")")
        
        // start the downloading
        self.task.resume()
    }
    override func cancel() {
         super.cancel()
       
         // cancel the downloading
         self.task.cancel()
     }
}
