//
//  Extensions.swift
//  Schedule
//
//  Created by My Mac on 10/3/21.
//

import SwiftUI

extension View {
    func palatinoFont(_ size:CGFloat, weight: FontWeight) -> some View {
        return self
            .font(PALATINO_FONT(size, weight: weight))
            .lineSpacing(0)
    }
}

private func PALATINO_FONT(_ size:CGFloat, weight: FontWeight) -> Font {
    let weight = weight == .bold ? "-Bold" : ""
    return Font.custom("Palatino\(weight)", size: size)
}

enum FontWeight {
    case regular, bold
}
