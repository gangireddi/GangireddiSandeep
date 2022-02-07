//
//  Track.swift
//  Gangireddi
//
//  Created by Sandeep on 01/02/22.
//

struct Track: Decodable {
    let wrapperType: String
    let kind: String
    let artistId: Int
    let collectionId: Int
    let trackId: Int
    let artistName: String
    let collectionName: String
    let trackName: String
    let collectionCensoredName: String
    let previewUrl: String
}
