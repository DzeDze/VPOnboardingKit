//
//  File.swift
//  VPOnboardingKit
//
//  Created by Vince P. Nguyen on 2024-12-11.
//

import UIKit
import SnapKit

class TitleView: UIView {
    
    private let themeFont: UIFont
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = themeFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(themeFont: UIFont) {
        self.themeFont = themeFont
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    private func layout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
