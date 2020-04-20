//
//  Animations.swift
//  LoginWindow
//
//  Created by 12dot on 23.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import UIKit

func shake(view: UIView, for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
    view.alpha = 1
    let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1
        view.transform = CGAffineTransform(translationX: translation, y: 0)
    }

    propertyAnimator.addAnimations({
        view.transform = CGAffineTransform(translationX: 0, y: 0)
    }, delayFactor: 0.2)

    propertyAnimator.addCompletion { (_) in
        view.layer.borderWidth = 0
    }

    propertyAnimator.startAnimation()
}

