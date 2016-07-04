//
//  UITableView+Extension.swift
//  CardBook
//
//  Created by DuongQuangloc on 2/4/16.
//  Copyright © 2016 Asian Tech Co.,Ltd. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib(cellIdentifier: String) {
        self.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    func registerNib<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let string = String(aClass)
        let nib = UINib(nibName: string, bundle: nil)
        registerNib(nib, forHeaderFooterViewReuseIdentifier: string)
    }

    func registerNib<T: UITableViewCell>(aClass: T.Type) {
        let string = String(aClass)
        let nib = UINib(nibName: string, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: string)
    }

    func dequeueTableView<E: UITableViewCell>(aClass: E.Type) -> E? {
        return dequeueReusableCellWithIdentifier(String(aClass)) as? E
    }

    func dequeueTableView<T: UITableViewHeaderFooterView>(aClass: T.Type) -> T? {
        return dequeueReusableHeaderFooterViewWithIdentifier(String(aClass)) as? T
    }

    func setAndLayoutTableHeaderView(header: UIView) {
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        tableHeaderView = header
    }
}
