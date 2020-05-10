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

## Classes

Class | Name | Status | Description
----|----|----|-----
UIViewController | UICHostingView | ✅ | It is used to host UICreator's View.
UINavigationController | UICNavigation | ✅ | It can be used the `UICNavigation.Other` to use custom navigations.
UITabController | UICTab | ✅ | Defines a tab bar with `UICTabItem` to create the tab views.
UIView | UICSpacer | ✅ | It contains a lot of properties from UIView and helps spacing content inside of it.
UIStackView | UICStack | ✅ | It has two variation `UICVStack` and `UICHStack`.
UILabel | UICLabel | ✅ | It shows the text on the screen.
UITextField | UICText | ✅ | Is a text that can be edited.
UITextView | UICTextView | ✅ | It is a scrollable text that can be edited.
UIScrollView | UICScroll | ✅ | Scrollable content with two variation `UICVScroll` and `UICHScroll`.
UIImageView | UICImage | ✅ | It shows image on screen.
UIButton | UICButton | ✅ | It is a view with control settings.
-- | UICRounder | ✅ | It is used to set `cornerRadius` and border layout
-- | UICZStack | ✅ | It shows more than one child view.
-- | UICViewRepresentable | ✅ | It is used to make UIKit view a UICreator view.
UITableView | UICList | 🟡 | It list views using `UICRow`, `UICHeader`, `UICFooter` and `UICSection`. Only some features are implemented.
UICollectionView | UICCollection | ❌ | It list view using `UICRow`, `UICHeader`, `UICFooter` and `UICSection`. It can be used `UICFlow` that uses `UICollectionFlowLayout`. To create the layout to views, use `layoutMaker(_:)`. Only some features are implemented.

## Reactive Objects

Object | Status | Description
----|----|-----
Value | ✅ | Store value inside view. Using the `$` it will turn into a `Relay` object.
Relay | 🟡 | It is used to update view property with `sync(_:)` or `next(_:)`. There are other special properties like `bind(to:)`, `map(_:)`. It needs more methods to be more flexible.

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
