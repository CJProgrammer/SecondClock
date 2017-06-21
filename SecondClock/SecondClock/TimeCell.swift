//
//  TimeCell.swift
//  SecondClock
//
//  Created by CJ on 2017/6/21.
//  Copyright 2017 CJ. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func timeCellWithTableView(tableView:UITableView) -> TimeCell {
        let identifier: String = "TimeCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UINib.init(nibName: "TimeCell", bundle: Bundle.main).instantiate(withOwner: self, options: nil).last as? UITableViewCell
        }
        
        return cell as! TimeCell
    }
    
    func setData(num:String,time:String,timeInterval:String) {
        numLabel.text = num
        timeLabel.text = time
        timeIntervalLabel.text = timeInterval
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}





