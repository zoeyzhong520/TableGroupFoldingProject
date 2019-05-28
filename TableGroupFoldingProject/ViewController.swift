//
//  ViewController.swift
//  TableGroupFoldingProject
//
//  Created by zhifu360 on 2019/5/28.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    ///创建UITableView
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: BaseTableReuseIdentifier)
        table.sectionHeaderHeight = 50
        table.rowHeight = 44
        table.separatorStyle = .none
        return table
    }()
    
    ///数据源
    var dataArray = [FoldingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
        requestAPI()
    }

    func setPage() {
        title = "演示"
        view.addSubview(tableView)
    }

    func requestAPI() {
        let dict = Bundle.readDataWith(fileName: "content", fileType: "json")
        let tmpArr = dict["data"] as! [[String: Any]]
        for item in tmpArr {
            let model = FoldingModel.initModel(title: item["title"] as? String, isShow: item["isShow"] as? Bool)
            dataArray.append(model)
        }
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].isShow == true ? 6 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableReuseIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SectionHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 50), section: section, delegate: self, title: dataArray[section].title)
    }
    
}

extension ViewController: SectionHeaderViewDelegate {
    
    func sectionHeaderViewClick(sectionHeaderView: SectionHeaderView, section: Int) {
        let isShow = dataArray[section].isShow
        dataArray[section].isShow = !isShow!
        
        //刷新对应分组
        tableView.reloadSections(IndexSet(integer: section), with: .fade)
    }
    
}
