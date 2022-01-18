//
//  MyCell.swift
//  ExSkeletonView
//
//  Created by Jake.K on 2022/01/18.
//

import UIKit
import SnapKit
import SkeletonView

class MyCell: UITableViewCell {
  private enum Metric {
    static let imageWidth = UIScreen.main.bounds.width * 1 / 3
    static let imageHeight = UIScreen.main.bounds.height * 1 / 5
  }
  
  private let pictureImageView = UIImageView()
  private let titleLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 24)
    $0.isSkeletonable = true
  }
  private let descriptionLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 18)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.contentView.backgroundColor = .black
    self.contentView.addSubview(self.pictureImageView)
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.descriptionLabel)
    
    self.pictureImageView.snp.makeConstraints {
      $0.left.bottom.top.equalToSuperview().inset(16)
      $0.size.lessThanOrEqualTo(Metric.imageWidth).priority(.high)
    }
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.left.equalTo(self.pictureImageView.snp.right).offset(16)
      $0.right.equalToSuperview().inset(16)
    }
    self.descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
      $0.left.equalTo(self.pictureImageView.snp.right).offset(16)
      $0.right.equalToSuperview().inset(16)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.prepare(picture: nil, title: nil, description: nil)
  }
  
  func prepare(picture: UIImage?, title: String?, description: String?) {
    self.pictureImageView.image = picture
    self.titleLabel.text = title
    self.descriptionLabel.text = description
  }
  
  required init?(coder: NSCoder) { fatalError() }
}
