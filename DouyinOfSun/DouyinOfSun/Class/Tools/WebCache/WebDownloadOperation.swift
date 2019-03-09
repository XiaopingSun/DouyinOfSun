//
//  WebDownloadOperation.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/7.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class WebDownloadOperation: Operation {
    private var progressBlock:WebDownloaderProgressBlock?
    private var completedBlock:WebDownloaderCompletedBlock?
    private var cancelBlock:WebDownloaderCancelBlock?
    
    private var session: URLSession?
    private var dataTask: URLSessionTask?
    private var request: URLRequest?
    
    private var imageData: Data?
    private var expectedSize: Int64?
    
    private var _executing: Bool = false
    private var _finished: Bool = false
    
    init(request: URLRequest, progress: @escaping WebDownloaderProgressBlock, completed: @escaping WebDownloaderCompletedBlock, cancel: @escaping WebDownloaderCancelBlock) {
        super.init()
        self.request = request
        self.progressBlock = progress
        self.completedBlock = completed
        self.cancelBlock = cancel
    }
    
    override func start() {
        willChangeValue(forKey: "isExecuting")
        _executing = true
        didChangeValue(forKey: "isExecuting")
        
        if(self.isCancelled) {
            done()
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 15
        
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        dataTask = session?.dataTask(with: request!)
        dataTask?.resume()
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func cancel() {
        objc_sync_enter(self)
        done()
        objc_sync_exit(self)
    }
    
    func done() {
        super.cancel()
        if(_executing) {
            willChangeValue(forKey: "isFinished")
            willChangeValue(forKey: "isExecuting")
            _finished = true
            _executing = false
            didChangeValue(forKey: "isFinished")
            didChangeValue(forKey: "isExecuting")
            reset()
        }
    }
    
    func reset() {
        if (dataTask != nil) {
            dataTask?.cancel()
        }
        if (session != nil) {
            session?.invalidateAndCancel()
            session = nil
        }
    }
}

extension WebDownloadOperation: URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = dataTask.response as! HTTPURLResponse
        let code = httpResponse.statusCode
        if(code == 200) {
            completionHandler(URLSession.ResponseDisposition.allow)
            imageData = Data.init()
            expectedSize = httpResponse.expectedContentLength
        }else {
            completionHandler(URLSession.ResponseDisposition.cancel)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if(completedBlock != nil) {
            if(error != nil) {
                let err = error! as NSError
                if(err.code == NSURLErrorCancelled) {
                    cancelBlock?()
                }else {
                    completedBlock?(nil, error, false)
                }
            }else {
                completedBlock?(imageData!, nil, true)
            }
        }
        done()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        imageData?.append(data)
        if(progressBlock != nil) {
            progressBlock?(Int64(imageData?.count ?? 0), expectedSize ?? 0)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let cacheResponse = proposedResponse
        if(request?.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData) {
            completionHandler(nil)
            return
        }
        completionHandler(cacheResponse)
    }
}
