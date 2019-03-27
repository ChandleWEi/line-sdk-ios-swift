//
//  SelectedTargetViewCell.swift
//
//  Copyright (c) 2016-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

class SelectedTargetViewCell: UICollectionViewCell {
    enum Design {
        static let size = CGSize(width: 50, height: 65)
        static let profileFrame = CGRect(x: 0, y: 4, width: 45, height: 45)
        static let nameFrame = CGRect(x: 0, y: 52, width: 50, height: 10)
        static let deleteFrame = CGRect(x: 29, y: 0, width: 21, height: 21)
    }

    private let profileImageView = UIImageView(frame: Design.profileFrame)
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: "#596478")
        label.font = UIFont.systemFont(ofSize: 12)
        label.frame = Design.nameFrame
        label.numberOfLines = 1
        label.textAlignment = .center

        return label
    }()

//    private let deleteIcon: UIImageView = {
//        let imageView = UIImageView(image: UIImage.listIconDeleteNormal)
//        imageView.frame = Design.deleteFrame
//        return imageView
//    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureContent()
    }

    private func configureContent() {
        contentView.addSubview(profileImageView)
//        contentView.addSubview(deleteIcon)
        contentView.addSubview(nameLabel)
    }
}
