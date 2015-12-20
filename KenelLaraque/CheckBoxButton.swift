//
//  CheckBoxButton.swift
//  KenelLaraque
//
//  Created by nikenson midi on 12/19/15.
//  Copyright © 2015 pnmidi. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {

   //Set up images
    let checkImage = UIImage(named: "wi")
    let unCheckImage = UIImage(named: "non")
    
    var isChecked: Bool = false{
        didSet{
            // updates ishcheckes when changes
            if isChecked == true{
                self.setImage(checkImage, forState: .Normal)
            }else{   
            self.setImage(unCheckImage, forState: .Normal)
            }
        }
    }//isChecked is done
    
    override func awakeFromNib() {
        self.addTarget(self, action: "clickTheButton:", forControlEvents: UIControlEvents.TouchUpInside)
    self.isChecked = false
    }
    
    func clickTheButton(sender:UIButton){
        if sender == self{
            if isChecked == true{
                isChecked = false
            }else{
                isChecked = true
            }
        }
    }
    
    
    
    
    
    
}
