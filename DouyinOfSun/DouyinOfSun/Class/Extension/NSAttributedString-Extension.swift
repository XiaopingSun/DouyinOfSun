//
//  NSAttributedString-Extension.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/26.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func multiLineSize(width:CGFloat) -> CGSize {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return CGSize(width: rect.size.width, height: rect.size.height)
    }
}
