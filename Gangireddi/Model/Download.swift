//
//  Download.swift
//  Gangireddi
//
//  Created by Sandeep on 02/02/22.
//

import UIKit

class Download {
  var isDownloading = false
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: Track
  
  init(track: Track) {
    self.track = track
  }
}
