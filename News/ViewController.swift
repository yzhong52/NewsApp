//
//  ViewController.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices
class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let client = NewsClient()

    private var articles: [Article] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 134
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self

        client.headlines().subscribe(
            onSuccess: { [weak self] (response) in
                self?.articles = response.articles
                self?.tableView.reloadData()
            },
            onError: { error in
                print("Received error \(error)")
        }).disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = articles[indexPath.row]
        tableViewCell.textLabel?.text = article.title
        return tableViewCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        present(SFSafariViewController(url: article.url), animated: true, completion: nil)
    }
}
