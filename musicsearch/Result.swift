//
//  Result.swift
//  musicsearch
//
//  Created by Javid Poornasir on 7/7/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit 

struct Result {
    
    private var _mainImage: UIImage?
    private var _song: String?
    private var _artist: String?
    private var _album: String?
    
    var mainImage: UIImage { return (_mainImage != nil) ? _mainImage! : UIImage() }
    var song: String { return (_song != nil) ? _song! : "" }
    var artist: String { return (_artist != nil) ? _artist! : "" }
    var album: String { return (_album != nil) ? _album! : "" }
    
    init() {}
    
    init(mainImage: UIImage, song: String, artist: String, album: String) {
        self._mainImage = mainImage
        self._song = song
        self._artist = artist
        self._album = album
    }
}
