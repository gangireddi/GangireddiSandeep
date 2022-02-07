//
//  TracksViewController.swift
//  Gangireddi
//
//  Created by Sandeep on 01/02/22.
//

import UIKit

class TracksViewController: UIViewController {

    @IBOutlet weak var tracksTableView: UITableView!
    var tracksList = [Track]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiHandler().callApi {[weak self] (result) in
            
            switch result {
            case .success(let results):
                self?.tracksList = results.results
                
            case .failure(let networkError):
                print(networkError)
                switch networkError {
                case .inValidUrl(let msg):
                    print(msg)
                default:
                    print("Error")
                }
            }
            
            
            DispatchQueue.main.async {
                self?.tracksTableView.reloadData()
            }
        }

        // Do any additional setup after loading the view.
    }
}
extension TracksViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        let objTrack: Track = tracksList[indexPath.row]
        cell.titleLbl.text = objTrack.artistName
        cell.subTitleLbl.text = objTrack.collectionName
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracksList.count
    }
}

//MARK: -----URLSessionDownloadDelegate method implementation-----

extension TracksViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
}
