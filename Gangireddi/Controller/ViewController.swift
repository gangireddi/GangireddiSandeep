//
//  ViewController.swift
//  Gangireddi
//
//  Created by Sandeep on 31/01/22.
//

import UIKit

class ViewController: UIViewController,URLSessionDownloadDelegate {
    
    @IBOutlet weak var progressLabel: UILabel!
    let urls = [
        URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/currentLocation/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/DispatchQueue/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/dynamicFont/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/telegrammy/archive/master.zip")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        let searchTerm = "Music"
        // 1
        dataTask?.cancel()
            
        // 2
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
          urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
          // 3
          guard let url = urlComponents.url else {
            return
          }
          // 4
          dataTask =
            defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
//              self?.dataTask = nil
            }
            // 5
            if let error = error {
//              self?.errorMessage += "DataTask error: " +
                                      error.localizedDescription + "\n"
            } else if
              let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode == 200 {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
//              self?.updateSearchResults(data)
              // 6
              DispatchQueue.main.async {
//                completion(self?.tracks, self?.errorMessage ?? "")
              }
            }
          }
          // 7
          dataTask?.resume()
        }
        
        return
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgIdentifier")
//        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.isDiscretionary = false
        configuration.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        //https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Polarlicht_2.jpg/1920px-Polarlicht_2.jpg?1568971082971
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
        session.invalidateAndCancel()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = (totalBytesWritten*100) / totalBytesExpectedToWrite
        print("\(percentDownloaded)%")
        
        DispatchQueue.main.async {
            self.progressLabel.text = "\(percentDownloaded)%"
        }
        
//        print("bytesWritten: \(bytesWritten)")
        print("totalBytesWritten: \(totalBytesWritten)")
        print("totalBytesExpectedToWrite: \(totalBytesExpectedToWrite)")
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
