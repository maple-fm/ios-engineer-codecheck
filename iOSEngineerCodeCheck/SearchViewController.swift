//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var SearchBar: UISearchBar?
    
    var repository: [[String: Any]]=[]
    var task: URLSessionTask?
    private var word: String?
    private var url: String?
    var idx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let SearchBar = self.SearchBar {
            SearchBar.text = "GitHubのリポジトリを検索できるよー"
            SearchBar.delegate = self
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // NOTE: 初期のテキストを消すための処理
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard
            let task = task
        else { return }
        task.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard
            let word = searchBar.text
        else { return }

        if word.count == 0 {
            return
        }

        url = "https://api.github.com/search/repositories?q=\(word)"
        task = URLSession.shared.dataTask(with: URL(string: url ?? "")!) { (data, res, err) in
            if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                if let items = obj["items"] as? [[String: Any]] {
                    self.repository = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        // NOTE: resume()を呼ばないとリストが更新されない
        if let task = task {
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard
                let detail = segue.destination as? DetailViewController
            else { return }

            detail.searchVC = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repository.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let repository = repository[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    // NOTE: 画面遷移時に呼ばれる
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
}
