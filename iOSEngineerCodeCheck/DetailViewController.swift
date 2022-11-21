//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var ImageLabel: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LangLabel: UILabel!
    @IBOutlet weak var StrsLabel: UILabel!
    @IBOutlet weak var WchsLabel: UILabel!
    @IBOutlet weak var Frkslabel: UILabel!
    @IBOutlet weak var IsssLabel: UILabel!
    
    var searchVC: SearchViewController!
        
    override func viewDidLoad() {

        super.viewDidLoad()
        let repository = searchVC.repository[searchVC.index]

        LangLabel.text = "Written in \(repository["language"] as? String ?? "")"
        StrsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        WchsLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        Frkslabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        IsssLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage()

    }
    
    func getImage(){
        
        let repository = searchVC.repository[searchVC.index]
        TitleLabel.text = repository["full_name"] as? String
        
        if let owner = repository["owner"] as? [String: Any] {
            if let imageURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, res, err) in
                    let image = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.ImageLabel.image = image
                    }
                }
                .resume()
            }
        }
    }
}
