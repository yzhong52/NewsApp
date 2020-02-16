//
//  NewsTableViewCell.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 3
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()

    let contentLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 4
        lable.textColor = .darkGray
        lable.font = UIFont.systemFont(ofSize: 12)
        return lable
    }()

    let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        return imageView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()

    private let rightVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(horizontalStackView)

        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
        ])

        horizontalStackView.addArrangedSubview(thumbnailView)

        rightVerticalStackView.addArrangedSubview(titleLabel)
        rightVerticalStackView.addArrangedSubview(contentLabel)
        horizontalStackView.addArrangedSubview(rightVerticalStackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
