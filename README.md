# UICreator

[![Swift](https://github.com/umobi/UICreator/workflows/Swift/badge.svg)](https://cocoapods.org/pods/UICreator)
[![Version](https://img.shields.io/cocoapods/v/UICreator.svg?style=flat)](https://cocoapods.org/pods/UICreator)
[![License](https://img.shields.io/cocoapods/l/UICreator.svg?style=flat)](https://cocoapods.org/pods/UICreator)
[![Platform](https://img.shields.io/cocoapods/p/UICreator.svg?style=flat)](https://cocoapods.org/pods/UICreator)

## Installation

UICreator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UICreator'
```

## Code Example

Go check this repository [UICreator Examples](https://github.com/brennobemoura/UICreator-Examples) to learn and test the library.

    import UICreator
    class LandmarkRow: UICView {
		let landmark: Landmark
		
		init(landmark: Landmark) {
			self.landmark = landmark
		}
	
		var body: ViewCreator {
			UICSpacer(vertical: 5) {
				UICHStack {[
					UICImage(image: self.landmark.image)
						.aspectRatio()
						.height(equalTo: 50)
						.content(mode: .scaleAspectFill)
						.clipsToBounds(true),
						
					UICLabel(self.landmark.name),
					UICSpacer()
				]}
				.spacing(15)
			}
		}
	}

## Author

brennobemoura, brenno@umobi.com.br

## License

UICreator is available under the MIT license. See the LICENSE file for more info.
