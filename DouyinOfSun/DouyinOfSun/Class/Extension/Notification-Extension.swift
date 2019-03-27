//
//  Notification-Extension.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/26.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

extension Notification {
    func keyBoardHeight() -> CGFloat {
        if let userInfo = self.userInfo {
            if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let size = value.cgRectValue.size
                return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
            }
        }
        return 0
    }
}

