//
//  topwheeliesTableViewCell.swift
//  Stunt
//
//  Created by Casey Shimata on 4/27/17.
//  Copyright © 2017 Casey Shimata. All rights reserved.
//

import UIKit

class topwheeliesTableViewCell: UITableViewCell {
    @IBOutlet weak var topwheelie_username: UILabel!
    @IBOutlet weak var topwheelie_datetime: UILabel!
    @IBOutlet weak var topwheelie_avgspeed: UILabel!
    @IBOutlet weak var topwheelie_avgangle: UILabel!
    @IBOutlet weak var topwheelie_totalangle: UILabel!
    @IBOutlet weak var topwheelie_totaldistance: UILabel!
    @IBOutlet weak var topwheelie_totaltime: UILabel!
    
    
    private var _model: CellData?
    // model is used in the table view cell setter
    var model: CellData {
        set {
            ///a key word that grabs the Tasks db item at the index
            _model = newValue
            
            //do some stuff
            set_db_item_at_index_to_cell_items()
        }
        get{
            return _model!
        }
    }
    
    
    /// sets the db items up after asking for them above ^^ and places them in the custom cells
    func set_db_item_at_index_to_cell_items(){
        print("***** creating the cell ----MY stuntstableviewCell 41")
        topwheelie_avgspeed.text = "\(String(describing: round(_model!.avg_speed!))) MPH"
        topwheelie_avgangle.text = "\(String(describing: round(_model!.avg_angle!)))°"
        topwheelie_totalangle.text = "\(String(describing: round(_model!.total_angle!)))°"
        topwheelie_totaltime.text = "\(String(describing: _model!.total_time!)) Seconds"
        topwheelie_totaldistance.text = "\(String(describing: _model!.total_distance!)) Feet"
        topwheelie_username.text = _model?.username
        topwheelie_datetime.text = _model?.createdAt
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
