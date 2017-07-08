//
//  ViewController.swift
//  musicsearch
//
//  Created by Javid Poornasir on 7/6/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit
import Alamofire

class ResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {

    @IBOutlet weak var sb: UISearchBar!
    @IBOutlet weak var tv: UITableView!

    var results: [Result]? = []
    var searchURL = String()
    var itemImg: UIImage? = nil
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sb.delegate = self
        tv.delegate = self
        tv.dataSource = self
    }
    
    func parseData(jsonData: [String: AnyObject]) {
        self.results = [Result]()
           
            if let items = jsonData["results"] as? [[String: AnyObject]] {
                
                    for item in items {
                        if let artistName = item["artistName"] as? String,
                            let albumName = item["collectionCensoredName"] as? String,
                            let imageURL = item["artworkUrl100"] as? String,
                            let songName = item["trackCensoredName"] as? String {
                            
                            DispatchQueue.global(qos: .background).async(execute: { 
                                do {
                                    if imageURL != "" {
                                        let imgData = try Data(contentsOf: URL(string: imageURL)!)
                                        self.itemImg = UIImage(data: imgData)
                                    }
                                    
                                    DispatchQueue.main.async(execute: { 
                                        let result = Result(mainImage: self.itemImg!, song: songName, artist: artistName, album: albumName)
                                        
                                        self.results?.append(result)
                                        self.tv.reloadData()
                                    })
                                    
                                } catch let error {
                                    print("PRINTING ERROR IN PARSEDATA() --- \(error)")
                                }
                            })
                        }
                    }
                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsVCtoResultDetailsVC-Segue" {
            guard let vc = segue.destination as? ResultDetailsVC else { return }
            if let resultObj = results, resultObj.count > index {
                vc.result = resultObj[index]
            }
        }
    }
  
    // MARK: - Search Bar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = sb.text
        let newKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        searchURL = "https://itunes.apple.com/search?term=\(newKeywords!)"
        DataManager.makeRequest(url: searchURL, completionHandler: { (jsonData, error) in
            if error == nil {
                self.parseData(jsonData: jsonData!)
            } else {
                print("PRINTING ERROR IN SEARCHBARSEARCHBUTTONCLICKED() --- \(error.debugDescription)")
                // We can return feedback to the user here
            }
        })
        
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if sb.text == "" {
            results!.removeAll()
            tv.reloadData()
        }
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! songCell
        let result = self.results?[indexPath.row]
        cell.updateUI(result: result!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       index = indexPath.row
       tableView.deselectRow(at: indexPath, animated: true)
       self.performSegue(withIdentifier: "ResultsVCtoResultDetailsVC-Segue", sender: self)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        
    }
    
}

