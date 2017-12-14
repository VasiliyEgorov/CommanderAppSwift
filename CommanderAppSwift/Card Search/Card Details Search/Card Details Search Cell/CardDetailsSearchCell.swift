//
//  CardDetailsSearchCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

protocol CardDetailsSearchCellDelegate : class {
    func CardDetailsSearchCellDidTapZoom(_ sender: UIButton)
    func CardDetailsSearchCellDidTapRefresh(_ sender: UIButton)
}

class CardDetailsSearchCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardLegalitiesLabel: UILabel!
    @IBOutlet weak var cardRarityLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    private var indicator : UIActivityIndicatorView!
    private var refreshButton : UIButton?
    weak var delegate : CardDetailsSearchCellDelegate?
    
    weak var viewModel : CardDetailsSearchCellViewModel! {
        didSet {
            cardNameLabel.text = viewModel.card.cardName
            cardTypeLabel.text = viewModel.card.type
            cardRarityLabel.text = viewModel.card.rarity
            cardLegalitiesLabel.text = viewModel.legalities
            viewModel.updateCardImage(onSuccess: { (image) in
                self.refreshButton?.removeFromSuperview()
                self.indicator.stop()
                self.networkActivityStop()
                self.cardImage.image = image
                self.addZoomButton()
            }) { (error) in
                if error?.code == Constants().noConnection {
                    self.indicator.stop()
                    self.networkActivityStop()
                    self.cardImage.image = UIImage.init(named: "cardBlur.png")
                    self.addRefreshButton()
                    
                } else {
                    self.indicator.stop()
                    self.networkActivityStop()
                    self.addNoSignImageView()
                    
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.networkActivityStart()
        indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        cardLegalitiesLabel.numberOfLines = 0
        cardImage.layer.cornerRadius = 5.0
        cardImage.layer.borderWidth = 1.0
        cardImage.layer.borderColor = UIColor.color_150withAlpha(alpha: 1).cgColor
        cardImage.layer.masksToBounds = true
        cardImage.clipsToBounds = true
        cardImage.isUserInteractionEnabled = true
        cardImage.addSubview(indicator)
        addConstraints(view: indicator)
        indicator.start()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let selectedBGView = UIView.init()
        selectedBGView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bgForCellHighlighted.png")!)
        self.selectedBackgroundView = selectedBGView
    }
    // MARK: - No Sign Image View
    
    private func addNoSignImageView() {
        let noSignImageView = UIImageView.init(image: UIImage.init(named: "noImageSign.png"))
        noSignImageView.layer.shadowColor = UIColor.black.cgColor
        noSignImageView.layer.shadowRadius = 0.5
        noSignImageView.layer.shadowOpacity = 1.0
        noSignImageView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        noSignImageView.layer.masksToBounds = false
        cardImage.addSubview(noSignImageView)
        addConstraints(view: noSignImageView)
    }
    // MARK: - Buttons
    private func addRefreshButton() {
        refreshButton = UIButton.init(type: .system)
        refreshButton?.frame = CGRect.zero
        refreshButton?.setBackgroundImage(UIImage.init(named: "refreshForCard.png"), for: .normal)
        refreshButton?.addTarget(self, action: #selector(refreshButtonAction(_:)), for: .touchUpInside)
        refreshButton?.layer.shadowColor = UIColor.black.cgColor
        refreshButton?.layer.shadowRadius = 1.0
        refreshButton?.layer.shadowOpacity = 1.0
        refreshButton?.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        refreshButton?.layer.masksToBounds = false
        cardImage.addSubview(refreshButton!)
        addConstraints(view: refreshButton!)
    }
    private func addZoomButton() {
        let zoomButton = UIButton.init(type: .system)
        zoomButton.frame = CGRect.zero
        zoomButton.backgroundColor = .clear
        zoomButton.addTarget(self, action: #selector(zoomButtonAction(_:)), for: .touchUpInside)
        zoomButton.layer.shadowColor = UIColor.black.cgColor
        zoomButton.layer.shadowRadius = 1.0
        zoomButton.layer.shadowOpacity = 1.0
        zoomButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        zoomButton.layer.masksToBounds = false
        cardImage.addSubview(zoomButton)
        addConstraintsToZoomButton(button: zoomButton)
    }
    
    @objc func refreshButtonAction(_ sender: UIButton) {
      delegate?.CardDetailsSearchCellDidTapRefresh(sender)
    }
    @objc func zoomButtonAction(_ sender: UIButton) {
        delegate?.CardDetailsSearchCellDidTapZoom(sender)
    }
    // MARK: - Constraints
    private func addConstraints(view: UIView) {
        
        var multiplierHeight : CGFloat
        var multiplierWidth : CGFloat
        if let _ = view as? UIActivityIndicatorView {
            multiplierHeight = 0.2
            multiplierWidth = 0.4
        } else if let _ = view as? UIButton {
            multiplierHeight = 0.32
            multiplierWidth = 0.5
        } else {
            multiplierHeight = 0.28
            multiplierWidth = 0.45
        }
        let centerX = NSLayoutConstraint.init(item: view, attribute: .centerX, relatedBy: .equal, toItem: cardImage, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint.init(item: view, attribute: .centerY, relatedBy: .equal, toItem: cardImage, attribute: .centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: cardImage, attribute: .height, multiplier: multiplierHeight, constant: 0)
        let width = NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: cardImage, attribute: .width, multiplier: multiplierWidth, constant: 0)
        cardImage.addConstraint(centerX)
        cardImage.addConstraint(centerY)
        cardImage.addConstraint(height)
        cardImage.addConstraint(width)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    private func addConstraintsToZoomButton(button: UIButton) {
        let top = NSLayoutConstraint.init(item: cardImage, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint.init(item: cardImage, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint.init(item: cardImage, attribute: .leading, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint.init(item: cardImage, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0)
        cardImage.addConstraint(top)
        cardImage.addConstraint(bottom)
        cardImage.addConstraint(leading)
        cardImage.addConstraint(trailing)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
}
