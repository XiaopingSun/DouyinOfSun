//
//  MyIconDetailViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/11.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

protocol MyIconDetailViewControllerDelegate: class {
    func iconDetailViewController(viewController: MyIconDetailViewController, didSelectedDownloadToAlbum image: UIImage?)
}

class MyIconDetailViewController: BaseViewController {
    
    var portraitUrlStr: String?
    weak var delegate: MyIconDetailViewControllerDelegate?
    
    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView(frame: CGRect.zero)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setImageWithURL(imageUrl: URL(string: portraitUrlStr ?? "")!, completed: {[weak self] (image, error) in
            self?.iconImageView.image = image
        })
        return iconImageView
    }()
    
    private lazy var downloadButton: UIButton = {
        let downloadButton = UIButton(type: UIButton.ButtonType.custom)
        downloadButton.setImage(UIImage(named: "icon_download_40_20x20_"), for: .normal)
        downloadButton.backgroundColor = UIColor.clear
        downloadButton.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        return downloadButton
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarStyle = .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func downloadAction() {
        if portraitUrlStr != nil {
            delegate?.iconDetailViewController(viewController: self, didSelectedDownloadToAlbum: iconImageView.image)
        }
    }
}

extension MyIconDetailViewController {
    private func setupUI() {
        view.addSubview(iconImageView)
        view.addSubview(downloadButton)
        
        iconImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        downloadButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().offset(-20)
        }
    }
}
