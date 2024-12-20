# VPOnboardingKit

VPOnboardingKit provides an onboarding flow that is simple and easy to implement.

![Demo](https://github.com/DzeDze/VPOnboardingKit/blob/main/demo.gif?raw=true)

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.0 or later


## Installation


### Swift Package Manager

To integrate VPOnboardingKit into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/DzeDze/VPOnboardingKit.git", .upToNextMajor(from: "0.1.0"))
]
```

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate VPOnboardingKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'VPOnboardingKit'
```
### Manually

* Clone or download the package's repository to your machine.
```git clone https://github.com/DzeDze/VPOnboardingKit.git```

* Drag the downloaded folder containing the package source files into your Xcode project navigator.
* When prompted, choose to "Copy items if needed" and select the appropriate targets.
* This package has SnapKit as a dependency; you also need to add SnapKit to your project. [https://github.com/SnapKit/SnapKit](https://github.com/SnapKit/SnapKit)

---

## Usage

There are 3 ways to handle VPOnboardingKit actions. Choose the **ONE** you prefer: 

### Publishers

```swift 
import VPOnboardingKit
```
 
```swift
import Combine
```
```swift
import UIKit
import VPOnboardingKit
import Combine
class ViewController: UIViewController {
    private var onboardingKit: VPOnboardingKit?
    private var subscribers = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async { [unowned self] in
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

            self.onboardingKit?.lauchOnboarding(rootViewController: self)
            observeOnboardingKit()
        }
    }
```
Implement ```observeOnboardingKit()```

```swift
private func observeOnboardingKit() {
      onboardingKit?.nextButtonPublisher
          .receive(on: DispatchQueue.main)
          .sink(receiveValue: { index in
          print("DEBUG: next button is tapped at index: \(index)")
      }).store(in: &subscribers)
        
      onboardingKit?.getStartedButtonPublisher
          .receive(on: DispatchQueue.main)
          .sink(receiveValue: { [weak self] _ in
          guard let this = self else { return }
          this.onboardingKit?.dismissOnboarding(animated: true, completion: nil)
          this.onboardingKit = nil
          print("DEBUG: getStartedButtonTapped")
      }).store(in: &subscribers)
  }
```
### Closures

Implement ```setupClosures()```

```swift
private func setupClosures() {
        onboardingKit?.nextDidTapped = { [weak self] index in
            print("DEBUG: next button is tapped at index: \(index)")
        }
        
        onboardingKit?.getStartedDidTapped = { [weak self] in
            self?.onboardingKit?.dismissOnboarding(animated: true, completion: nil)
            self?.onboardingKit = nil
            print("DEBUG: getStartedButtonTapped")
        }
    }
```

### Delegate 

Initialize and set up VPOnboardingKit where appropriate, such as in ```viewDidLoad```:

```swift
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
                tintColor: UIColor(red: 223/255, green: 109/255, blue: 48/255, alpha: 1.0))
            self.onboardingKit?.delegate = self
            self.onboardingKit?.lauchOnboarding(rootViewController: self)
        }
    }
}
  
```
Consider implementing the ```VPOnboardingKitDelegate``` to handle 'Next' and 'Get Started' buttons:

```swift
extension ViewController: VPOnboardingKitDelegate {
    func getStartedButtonTapped() {
        print("DEBUG: getStartedButtonTapped")
    }
    
    func onboardNextButtonTapped(atIndex index: Int) {
        print("DEBUG: next button is tapped at index: \(index)")
    }
}
```
## License
VPOnboardingKit is released under the MIT license.
