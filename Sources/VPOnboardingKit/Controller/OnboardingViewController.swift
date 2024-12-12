//
//  File.swift
//  VPOnboardingKit
//
//  Created by Vince P. Nguyen on 2024-12-11.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    private let slides: [Slide]
    private let slideDurationInSeconds: Int
    private let tintColor: UIColor
    private let themeFont: UIFont
    
    var nextButtonDidTap: ((Int) -> Void)?
    var getStartedButtonDidTap: (() -> Void)?
      
    private lazy var transitionView: TransitionView = {
        let view = TransitionView(
            slides: slides,
            slideDurationInSeconds: slideDurationInSeconds,
            tintColor: tintColor,
            themeFont: themeFont
        )
        return view
    }()
    
    private lazy var buttonContainerView: ButtonContainerView = {
        let view = ButtonContainerView(tintColor: tintColor)
        view.nextButtonDidTap = { [weak self] in
            guard let this = self else { return }
            this.nextButtonDidTap?(this.transitionView.currentSlideIndex)
            this.transitionView.handleTap(directions: .right)
        }
        view.getStartedButtonDidTap = getStartedButtonDidTap
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [transitionView, buttonContainerView])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    init(
        slides: [Slide],
        slideDurationInSeconds: Int,
        tintColor: UIColor,
        themeFont: UIFont
    ) {
        self.slides = slides
        self.slideDurationInSeconds = slideDurationInSeconds
        self.tintColor = tintColor
        self.themeFont = themeFont
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionView.start()
    }
    
    func stopAnimation() {
        transitionView.stop()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        buttonContainerView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        transitionView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        let touchedPoint = tap.location(in: transitionView)
        let midPoint = transitionView.bounds.midX
        
        if touchedPoint.x < midPoint {
            transitionView.handleTap(directions: .left)
        } else {
            transitionView.handleTap(directions: .right)
        }
    }
}
