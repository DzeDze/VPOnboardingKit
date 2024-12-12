//
//  File.swift
//  VPOnboardingKit
//
//  Created by Vince P. Nguyen on 2024-12-11.
//

import UIKit

class TransitionView: UIView {
    
    private var timer: Timer?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var barViews: [AnimatedBarView] = {
        var views: [AnimatedBarView] = []
        slides.forEach { _ in
            views.append(AnimatedBarView(barColor: viewTintColor, durationInSeconds: slideDurationInSeconds))
        }
        return views
    }()
    
    private lazy var barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        barViews.forEach { barView in
            stackView.addArrangedSubview(barView)
        }
        return stackView
    }()
    
    private lazy var titleView: TitleView = {
        let view = TitleView(themeFont: themeFont)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let slides: [Slide]
    private let slideDurationInSeconds: Int
    private let viewTintColor: UIColor
    private let themeFont: UIFont
    private var currentIndex: Int = -1
    
    var currentSlideIndex: Int {
        return currentIndex
    }
    
    init(
        slides: [Slide],
        slideDurationInSeconds: Int,
        tintColor: UIColor,
        themeFont: UIFont
    ) {
        self.slides = slides
        self.slideDurationInSeconds = slideDurationInSeconds
        self.viewTintColor = tintColor
        self.themeFont = themeFont
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        stop() // Stop any existing timer before starting a new one
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            
            DispatchQueue.main.async {
                self?.handleTimerEvent()
            }
        }
        // Start animation right away
        self.handleTimerEvent()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func handleTimerEvent() {
        showNext()
    }
    
    private func showNext() {
        var nextImage: UIImage
        var nextTitle: String
        var nextBarView: AnimatedBarView
        let nextIndex = currentIndex + 1
        if slides.indices.contains(nextIndex) {
            nextImage = slides[nextIndex].image
            nextTitle = slides[nextIndex].title
            nextBarView = barViews[nextIndex]
            currentIndex += 1
        } else {
            barViews.forEach { $0.reset() }
            nextImage = slides[0].image
            nextTitle = slides[0].title
            nextBarView = barViews[0]
            currentIndex = 0
        }
        
        UIView.transition(
            with: imageView,
            duration: 0.5,
            options: .transitionCrossDissolve) {
                self.imageView.image = nextImage
                
            }
        
        self.titleView.setTitle(nextTitle)
        nextBarView.startAnimating()
    }
    private func layout() {
        addSubview(stackView)
        addSubview(barStackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        barStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.top.equalTo(snp.topMargin)
            make.height.equalTo(4)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.8)
        }
    }
    
    func handleTap(directions: Directions) {
        switch directions {
        case .left:
            barViews[currentIndex].reset()
            if barViews.indices.contains(currentIndex - 1) {
                barViews[currentIndex - 1].reset()
            }
            currentIndex -= 2
            
        case .right:
            barViews[currentIndex].complete()
        }
        stop()
        start()
    }
}
