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
    private let manager = NewsManager()

    private var articles: [Article] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 134
        return tableView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("News", comment: "")
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 9)
        return label
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

        let titleView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleView.axis = .vertical
        titleView.alignment = .center
        navigationItem.titleView = titleView
        
        manager.news().drive(onNext: { [weak self] (state) in
            self?.updateView(state: state)
        }).disposed(by: disposeBag)

    }
    private func updateView(state: NewsManager.NewsLoadState) {
        switch state {
        case .loading:
            subtitleLabel.text = NSLocalizedString("Loading...", comment: "")
        case .updating:
            subtitleLabel.text = NSLocalizedString("Updating...", comment: "")
        case .loaded(let response):
            articles = response.articles
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd YYYY HH:mm"
            let labelFormat = NSLocalizedString("%@ Updated", comment: "")
            subtitleLabel.text = String.localizedStringWithFormat(
                labelFormat, dateFormatter.string(from: Date()))
            tableView.reloadData()
        case let .failed(error):
            print("[Error] failed to load news \(error)")
            subtitleLabel.text = NSLocalizedString("Update Failed", comment: "")
        }
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
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell

        let article = articles[indexPath.row]
        tableViewCell.titleLabel.text = article.title
        tableViewCell.contentLabel.text = article.content

        if let urlToImage = article.urlToImage {
            tableViewCell.isHidden = false
            tableViewCell.thumbnailView.load(url: urlToImage)
        } else {
            tableViewCell.isHidden = true
        }

        return tableViewCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        present(SFSafariViewController(url: article.url), animated: true, completion: nil)
    }
}
