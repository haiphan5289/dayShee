//
//  ListFavouriteVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListFavouriteVC: UIViewController {

    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
extension ListFavouriteVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Danh sách sản phẩm yêu thích"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = 0.1
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(vLine.snp.bottom)
        }
        tableView.delegate = self
        tableView.register(ListFavouriteCell.nib, forCellReuseIdentifier: ListFavouriteCell.identifier)
    }
    private func setupRX() {
        Observable.just([1])
            .bind(to: tableView.rx.items(cellIdentifier: ListFavouriteCell.identifier, cellType: ListFavouriteCell.self)) {(row, element, cell) in
//                cell.lbContent.text = "heo dõi vụ việc, luật sư Đặng Văn Cường (Trưởng Văn phòng Luật sư Chính pháp) nhận định cơ quan điều tra cần làm rõ diễn biến hành vi, đặc biệt là việc sử dụng vũ lực, gây nguy hiểm cho nhau của hai bên, đồng thời làm rõ ý thức chủ quan, tương quan lực lượng và hậu quả để xác định những hành vi bị truy cứu trách nhiệm hình sự của anh Giao cũng như nhóm bắt cóc."
        }.disposed(by: disposeBag)
    }
}
extension ListFavouriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
