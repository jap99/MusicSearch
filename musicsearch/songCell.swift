//
//  songCell.swift
//  musicsearch
//
//  Created by Javid Poornasir on 7/6/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

class songCell: UITableViewCell {
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(result: Result) {
        self.trackLabel.text = "Track: \(result.song)"
        self.artistLabel.text = "Artist: \(result.artist)"
        self.albumLabel.text = "Album: \(result.album)"
        self.cellImage.image = result.mainImage
        
        cellImage.layer.cornerRadius = 8.0
        cellImage.clipsToBounds = true
    }
}
