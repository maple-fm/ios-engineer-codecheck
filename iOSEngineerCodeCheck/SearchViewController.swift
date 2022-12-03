//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

// MARK: vars and lifecycle
class SearchViewController: UITableViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    
    private var repository: [[String: Any]]=[]
    private var task: URLSessionTask?
    private var idx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let SearchBar = self.SearchBar {
            SearchBar.text = "GitHubのリポジトリを検索できるよー"
            SearchBar.delegate = self
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard
                let detail = segue.destination as? DetailViewController
            else { return }

            detail.repository = repository[self.idx ?? 0]
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

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

        let url = "https://api.github.com/search/repositories?q=\(word)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] (data, res, err) in
            if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                if let items = obj["items"] as? [[String: Any]] {
                    self?.repository = items
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        // NOTE: resume()を呼ばないとリストが更新されない
        if let task = task {
            task.resume()
        }
    }
}

// MARK: - UITableViewController
extension SearchViewController {

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
