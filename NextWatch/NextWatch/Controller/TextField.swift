//
//  TextField.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import Foundation
import UIKit


struct keybord
{
    let view = UIView()
    func keybord()
    {
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
}
