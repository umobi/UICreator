//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit

extension UICImage {

    @usableFromInline
    enum Content {
        case uiImage(UIImage)
        case cgImage(CGImage)
        case ciImage(CIImage)

        case contentsOfFile(String)
        case data(Data)

        case named(String)
        case namedWithScheme(String, Bundle?, ColorScheme)
        @available(iOS 13, tvOS 13, *)
        case namedWithConfiguration(String, Bundle?, UIImage.Configuration)

        @available(iOS 13, tvOS 13, *)
        case systemName(String)
        @available(iOS 13, tvOS 13, *)
        case systemNameWithScheme(String, ColorScheme)
        @available(iOS 13, tvOS 13, *)
        case systemNameWithConfiguration(String, UIImage.Configuration)
    }
}

extension UICImage.Content {

    var uiImage: UIImage! {
        if #available(iOS 13, tvOS 13, *) {
            switch self {
            case .namedWithConfiguration(let string, let bundle, let configuration):
                return UIImage(named: string, in: bundle, with: configuration)

            case .systemName(let string):
                return UIImage(systemName: string)
            case .systemNameWithScheme(let string, let colorScheme):
                return UIImage(
                    systemName: string,
                    compatibleWith: .init(userInterfaceStyle: colorScheme.uiUserInterfaceStyle)
                )
            case .systemNameWithConfiguration(let string, let configuration):
                return UIImage(
                    systemName: string,
                    withConfiguration: configuration
                )
            default:
                break
            }
        }

        switch self {
        case .uiImage(let uiImage):
            return uiImage
        case .cgImage(let cgImage):
            return UIImage(cgImage: cgImage)
        case .ciImage(let ciImage):
            return UIImage(ciImage: ciImage)

        case .contentsOfFile(let path):
            return UIImage(contentsOfFile: path)
        case .data(let data):
            return UIImage(data: data)

        case .named(let string):
            return UIImage(named: string)
        case .namedWithScheme(let string, let bundle, let colorScheme):
            if #available(iOS 12, tvOS 12, *) {
                return UIImage(
                    named: string,
                    in: bundle,
                    compatibleWith: .init(userInterfaceStyle: colorScheme.uiUserInterfaceStyle)
                )
            }

            return UIImage(
                named: string,
                in: bundle,
                compatibleWith: nil
            )
        default:
            fatalError()
        }
    }
}
