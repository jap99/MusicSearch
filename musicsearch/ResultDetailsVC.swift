//
//  ResultDetailsVC.swift
//  musicsearch
//
//  Created by Javid Poornasir on 7/7/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

class ResultDetailsVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var trackLyricsView: UITextView!
    @IBOutlet weak var getCompleteLyricsButton: UIButton!
    
    var result: Result?
    var lyricsURL = ""
    var theURL = ""
    var lyricsExist = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modifyViews()
        guard let resultObject = result else { return }
        
        albumImage.image = resultObject.mainImage
        trackLabel.text = "Track: \(resultObject.song)"
        artistLabel.text = "Artist: \(resultObject.artist)"
        albumLabel.text = "Album: \(resultObject.album)"
        
        var searchParameter = "func=getSong&artist=\(resultObject.artist)&song=\(resultObject.song)&fmt=json"
        searchParameter = searchParameter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        lyricsURL = "http://lyrics.wikia.com/api.php?\(searchParameter)"
        
        self.callDataManager(lyricsURL)
    }
 
    func callDataManager(_ lyricsURL: String) {
        
        DataManager.makeRequest1(url: lyricsURL, completionHandler: { (jsonData, error) in
            
            if error == nil {
                self.parseData(jsonData: jsonData!)
                
            } else {
                print("PRINTING ERROR IN CALLDATAMANAGER() --- \(error.debugDescription)")
                self.lyricsExist = false
                // We can also return feedback to the user
            }
        })
        
    }
    
    func parseData(jsonData: [String: AnyObject]) {
        
        if var lyrics = jsonData["lyrics"] as? String {
            lyrics = lyrics.replacingOccurrences(of: "\"", with: "\'")
            self.trackLyricsView.text = lyrics
            self.lyricsExist = true
        } else {
            self.lyricsExist = false
        }
        
        if let url = jsonData["url"] as? String {
            getCompleteLyricsButton.isHidden = false
            self.theURL = url
        } else {
            getCompleteLyricsButton.isHidden = true
        }
    }
    
    @IBAction func goBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func modifyViews() {
        getCompleteLyricsButton.layer.cornerRadius = 1.0
        albumImage.layer.cornerRadius = 8.0
        albumImage.clipsToBounds = true
    }
    
    @IBAction func getCompleteLyricsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ResultDetailsVCtoPlayerVC-Segue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultDetailsVCtoPlayerVC-Segue" {
            
            guard let vc = segue.destination as? PlayerVC else { return }
            
            vc.theURL = self.theURL
            vc.lyricsExist = self.lyricsExist
        }
    }
}
