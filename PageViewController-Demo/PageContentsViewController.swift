//
//  PageViewController.swift
//  PageViewController-Demo
//
//  Created by JINSEOK on 2023/07/17.
//

import UIKit

class PageContentsViewController: UIViewController {
    
    private var stackView: UIStackView!
    
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
    }
    
    init(imageName: String, title: String, subTitle: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        subTitleLabel.font = .preferredFont(forTextStyle: .body)
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 0
        
        self.stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(view).multipliedBy(0.6)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(50)
        }
    }
}
