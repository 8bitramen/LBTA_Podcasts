//
//  CMTime.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/25/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let hours = totalSeconds / 3600
        let timeFormatString = hours > 0 ? String(format: "%02d:%02d:%02d", hours, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
    
}
