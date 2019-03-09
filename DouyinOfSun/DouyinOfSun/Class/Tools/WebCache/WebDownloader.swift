//
//  WebDownloader.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/6.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class WebDownloader: NSObject {
    private static let instance = WebDownloader()
    private var downloadQueue: OperationQueue?
    
    private override init() {
        super.init()
        downloadQueue = OperationQueue()
        downloadQueue?.name = "com.start.webdownloader"
        downloadQueue?.maxConcurrentOperationCount = 8
    }
    
    class func shared() -> WebDownloader {
        return instance
    }
    
    func download(url: URL, progress: @escaping WebDownloaderProgressBlock, completed: @escaping WebDownloaderCompletedBlock, cancel: @escaping WebDownloaderCancelBlock) -> WebCombineOperation {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 15)
        request.httpShouldUsePipelining = true
        let key = url.absoluteString
        let operation = WebCombineOperation()
        operation.cacheOperation = WebCacheManager.shared().queryDataFromMemory(key: key, cacheQueryCompletedBlock: { [weak self] (data, hasCache) in
            if hasCache {
                completed(data as? Data, nil, true)
            } else {
                let downloadOperation = WebDownloadOperation(request: request, progress: progress, completed: { (data, error, finished) in
                    if finished && error == nil {
                        WebCacheManager.shared().storeDataCache(data: data, key: key)
                        completed(data, nil, true)
                    } else {
                        completed(data, error, false)
                    }
                }, cancel: {
                    cancel()
                })
                operation.downloadOperation = downloadOperation
                self?.downloadQueue?.addOperation(downloadOperation)
            }
        })
        return operation
    }
}
