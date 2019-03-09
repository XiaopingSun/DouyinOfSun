//
//  WebCombineOperation.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/7.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class WebCombineOperation: NSObject {
    var cancelBlock: WebDownloaderCancelBlock?
    var cacheOperation: Operation?
    var downloadOperation: WebDownloadOperation?
    
    func cancel() {
        if cacheOperation != nil {
            cacheOperation?.cancel()
            cacheOperation = nil
        }
        
        if downloadOperation != nil {
            downloadOperation?.cancel()
            downloadOperation = nil
        }
        
        if(cancelBlock != nil) {
            cancelBlock?()
            cancelBlock = nil
        }
    }
}
