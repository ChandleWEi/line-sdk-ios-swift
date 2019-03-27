//
//  SelectedTargetView.swift
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

class SelectedTargetView: UIView {
    enum Design {
        static let height = CGFloat(79)
        static let bgColor = "#F7F8FA"
    }

    private let slideAnimationView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(rgb: Design.bgColor)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(rgb: "#E6E7EA").cgColor
        return view
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = SelectedTargetViewCell.Design.size

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(rgb: Design.bgColor)
        collectionView.alwaysBounceHorizontal = true
        collectionView.scrollsToTop = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        collectionView.register(
            SelectedTargetViewCell.self,
            forCellWithReuseIdentifier: SelectedTargetViewCell.defaultReuseIdentifier()
        )

        return collectionView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureContentView()
    }

    private func configureContentView() {
        addSubview(slideAnimationView)
        slideAnimationView.addSubview(collectionView)
        updateLayout(withAnimated: false)
    }

    func updateLayout(withAnimated animated: Bool = true) {
        // doing autolayout here
    }
}
