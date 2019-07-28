//
//  ViewController.swift
//  OfflineVideos
//
//  Created by Poonam on 27/07/19.
//  Copyright © 2019 Poonam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movie")
        fetchMoviesList()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vo]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vo":tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vo]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vo":tableView]))
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieTableViewCell
        cell.movieInfo = movies[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension ViewController {
    
    func fetchMoviesList() {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else { return }
        let data = try? Data(contentsOf: url)
        guard let unwrapped_data = data else { return }
        let movielist = try? JSONDecoder().decode([Movie].self, from: unwrapped_data)
        if let unwrapped_movies_list = movielist {
            self.movies = unwrapped_movies_list
            self.tableView.reloadData()
        }
    }
    
}

struct Movie: Decodable {
    let description: String?
    let sources: [String]?
    let subtitle: String?
    let thumb: String?
    let title: String?
}
