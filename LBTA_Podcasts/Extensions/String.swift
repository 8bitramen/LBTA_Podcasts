//
//  String.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/21/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTP() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "https", with: "https")
    }
}
