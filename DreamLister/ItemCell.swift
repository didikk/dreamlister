//
//  ItemCell.swift
//  DreamLister
//
//  Created by Didik Ismawanto on 2/18/17.
//  Copyright © 2017 Didik Ismawanto. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var detail: UILabel!
   
    func configureCell(item: Item){
        title.text = item.title
        price.text = "$\(item.price)"
        detail.text = item.detail
        thumbnail.image = item.toImage?.image as? UIImage    }
}
