//
//  UIImage+Downscale.swift
//  HappyBirthday
//

import UIKit

extension UIImage {
    /// Returns an image whose longest side is at most `maxDimension` pixels.
    /// Also redraws images that aren't `.up`, which bakes in the orientation
    /// (camera photos are often stored rotated).
    func downscaled(toMaxDimension maxDimension: CGFloat) -> UIImage {
        let longestSide = max(size.width, size.height)
        guard longestSide > 0,
              longestSide > maxDimension || imageOrientation != .up else { return self }

        let ratio = min(1, maxDimension / longestSide)
        let targetSize = CGSize(width: (size.width * ratio).rounded(),
                                height: (size.height * ratio).rounded())

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
