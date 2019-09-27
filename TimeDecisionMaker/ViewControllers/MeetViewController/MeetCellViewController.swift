//
//  MeetCellViewController.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/20/19.
//

import UIKit

class MeetCellViewController: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var StartMeetTime: UILabel!
    @IBOutlet weak var MeetingWillBeFor: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Recomendation: UILabel!
}
