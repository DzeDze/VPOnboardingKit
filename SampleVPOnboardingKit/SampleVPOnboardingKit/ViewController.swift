//
//  ViewController.swift
//  SampleVPOnboardingKit
//
//  Created by Vince P. Nguyen on 2024-12-12.
//

import UIKit
import VPOnboardingKit
class ViewController: UIViewController {
    private var onboardingKit: VPOnboardingKit?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.onboardingKit = VPOnboardingKit(
                slides: [
                    .init(image: UIImage(named: "imSlide1")!,
                          title: "The road to success is always under construction"),
                    .init(image: UIImage(named: "imSlide2")!,
                          title: "What I don’t like about office Christmas parties is looking for a job the next day"),
                    .init(image: UIImage(named: "imSlide3")!,
                          title: "The only place success comes before work is in the dictionary"),
                    .init(image: UIImage(named: "imSlide4")!,
                          title: "Whatever you do, always give 100% — unless you’re donating blood"),
                    .init(image: UIImage(named: "imSlide5")!,
                          title: "Find out what you like doing best and get someone to pay you for doing it"),
                ],
                slideDurationInSeconds: 3,
                tintColor: UIColor(red: 223/255, green: 109/255, blue: 48/255, alpha: 1.0),
                themeFont: UIFont(name: "ArialRoundedMTBold", size: 18) ?? .systemFont(ofSize: 18)
            )
            self.onboardingKit?.delegate = self
            self.onboardingKit?.lauchOnboarding(rootViewController: self)
        }
    }
    
    private func transit(viewController: UIViewController) {
      let foregroundScenes = UIApplication.shared.connectedScenes.filter({
        $0.activationState == .foregroundActive
      })
      
      let window = foregroundScenes
        .map({ $0 as? UIWindowScene })
        .compactMap({ $0 })
        .first?
        .windows
        .filter({ $0.isKeyWindow })
        .first
      
      guard let uWindow = window else { return }
      uWindow.rootViewController = viewController
      
      UIView.transition(
        with: uWindow,
        duration: 0.3,
        options: [.transitionCrossDissolve],
        animations: nil,
        completion: nil)
    }
}

extension ViewController: VPOnboardingKitDelegate {
    func getStartedButtonTapped() {
        onboardingKit?.dismissOnboarding(animated: true, completion: nil)
        onboardingKit = nil
        transit(viewController: MainViewController())
    }
    
    func onboardNextButtonTapped(atIndex index: Int) {
        print("next button is tapped at index: \(index)")
    }
}

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let label = UILabel()
    label.text = "Main View Controller"
    view.addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalTo(view)
    }
      view.backgroundColor = .yellow
  }
}


