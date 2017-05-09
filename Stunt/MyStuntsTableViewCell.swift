//
//  MyStuntsTableViewCell.swift
//  Pods
//
//  Created by Casey Shimata on 4/27/17.
//
//

import UIKit

class MyStuntsTableViewCell: UITableViewCell {
    @IBOutlet weak var date_time_outlet: UILabel!
    @IBOutlet weak var avg_speed_outlet: UILabel!
    @IBOutlet weak var avg_angle_outlet: UILabel!
    @IBOutlet weak var max_angle_outlet: UILabel!
    @IBOutlet weak var total_time_outlet: UILabel!
    @IBOutlet weak var total_distance_outlet: UILabel!
    @IBOutlet weak var stunt_type_outlet: UILabel!
    @IBOutlet weak var footage_LINK_outlet: UILabel!
    
    
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
        avg_speed_outlet.text = "\(String(describing: round(_model!.avg_speed!))) MPH"
        avg_angle_outlet.text = "\(String(describing: round(_model!.avg_angle!)))°"
        max_angle_outlet.text = "\(String(describing: round(_model!.total_angle!)))°"
        total_time_outlet.text = "\(String(describing: _model!.total_time!)) Seconds"
        total_distance_outlet.text = "\(String(describing: _model!.total_distance!)) Feet"
        stunt_type_outlet.text = _model?.stunt_type
        footage_LINK_outlet.text = _model?.video_url
        date_time_outlet.text = _model?.createdAt
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
