//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LangLabel: UILabel!
    @IBOutlet weak var StrsLabel: UILabel!
    @IBOutlet weak var WchsLabel: UILabel!
    @IBOutlet weak var Frkslabel: UILabel!
    @IBOutlet weak var IsssLabel: UILabel!
    
    var repository = [String: Any]()
        
    override func viewDidLoad() {

        super.viewDidLoad()

        LangLabel.text = "Written in \(repository["language"] as? String ?? "")"
        StrsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        WchsLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        Frkslabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        IsssLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        TitleLabel.text = repository["full_name"] as? String
        loadImage()
    }
    
    private func loadImage() {

        guard
            let owner = repository["owner"] as? [String: Any]
        else { return }

        guard
            let imageURL = owner["avatar_url"] as? String
        else { return }

        URLSession.shared.dataTask(with: URL(string: imageURL)!) { [weak self] (data, res, err) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.ImgView.image = image
                }
            }
        }
        .resume()
    }
}
