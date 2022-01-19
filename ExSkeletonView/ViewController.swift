//
//  ViewController.swift
//  ExSkeletonView
//
//  Created by Jake.K on 2022/01/18.
//

import UIKit
import SnapKit
import SkeletonView
import Then

class ViewController: UIViewController {
  private let tableView = UITableView().then {
    $0.register(MyCell.self, forCellReuseIdentifier: "cell")
    $0.backgroundColor = .white
    $0.isSkeletonable = true
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 160 // <- skeleton은 이것을 보고 cell의 height를 보여주므로 설정에 주의
  }
  private let label1 = UILabel().then {
    $0.text = "label1"
    $0.numberOfLines = 0
    $0.textColor = .black
    $0.isSkeletonable = true
  }
  private let label2 = UILabel().then {
    $0.text = "label2 ... description"
    $0.numberOfLines = 0
    $0.textColor = .black
    $0.isSkeletonable = true
  }
  private var dataSource = [MyData]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.label1)
    self.view.addSubview(self.label2)
    
    self.label1.snp.makeConstraints {
      $0.left.equalToSuperview().inset(24)
      $0.top.equalToSuperview().inset(62)
    }
    self.label2.snp.makeConstraints {
      $0.left.equalTo(self.label1)
      $0.top.equalTo(self.label1.snp.bottom).offset(12)
    }
    self.tableView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(120)
      $0.left.right.bottom.equalToSuperview()
    }
    
    self.tableView.dataSource = self
    self.view.isSkeletonable = true
    
    let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    self.view.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]), animation: skeletonAnimation, transition: .none)
    self.fetchDataSource()
  }
  
  private func fetchDataSource() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      let datas = (0...30)
        .map {
          MyData(
            image: UIImage(named: "jake"),
            title: "title \($0)",
            description: "description \($0)"
          )
        }
      self.dataSource.append(contentsOf: datas)
      self.tableView.reloadData()
      self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
      self.view.hideSkeleton()
    }
  }
}

extension ViewController: SkeletonTableViewDataSource {
  // tableView
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
    let data = dataSource[indexPath.row]
    cell.prepare(picture: data.image, title: data.title, description: data.description)
    return cell
  }
  
  // skeletonView
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "cell"
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
    skeletonView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    UITableView.automaticNumberOfSkeletonRows // <- 편리하게 사용 가능
  }
  
  func numSections(in collectionSkeletonView: UITableView) -> Int {
    1
  }
}
