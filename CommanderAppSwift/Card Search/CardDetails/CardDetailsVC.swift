//
//  CardDetailsVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CardDetailsVC: UIViewController {
    var viewModel : CardDetailsViewModel!
    private var refreshButton : UIButton?
    private var indicator : UIActivityIndicatorView!
    @IBOutlet weak var topStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var legalitiesLabel: UILabel!
    @IBOutlet weak var powerAndToughnessLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var cardTextLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var manaCostAndColorLabel: UILabel!
    deinit {
        viewModel.cancelDowloading()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGesture()
        setupSettings()
        setupBackButton()
        indicator.start()
        bindings()
        changeConstraints()
        self.networkActivityStart()
        getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.networkActivityStop()
    }
    // MARK: - Setup
    private func setupSettings() {
        cardImageView.isUserInteractionEnabled = true
        cardImageView.layer.cornerRadius = 10.0
        cardImageView.layer.borderWidth = 1.0
        cardImageView.layer.borderColor = UIColor.color_150withAlpha(alpha: 1).cgColor
        cardImageView.layer.masksToBounds = true
        cardImageView.clipsToBounds = true
        indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        cardImageView.addSubview(indicator)
        addConstraints(view: indicator)
        cardTextLabel.numberOfLines = 0
        legalitiesLabel.numberOfLines = 0
    }
    private func bindings() {
        cardNameLabel.text = viewModel.card.cardName
        manaCostAndColorLabel.text = String(viewModel.card.cmc) + Constants().space + viewModel.colorIdentity
        setLabel.text = viewModel.card.setName
        rarityLabel.text = viewModel.card.rarity
        cardTextLabel.text = viewModel.card.text
        legalitiesLabel.text = "Legal in: " + viewModel.legalities
        typeLabel.text = viewModel.card.type
        powerAndToughnessLabel.text = viewModel.card.cardPower + " / " + viewModel.card.cardToughness
    }
    // MARK: - Receive image
    
    private func getImage() {
        viewModel.updateCardImage(onSuccess: { (image) in
            self.refreshButton?.removeFromSuperview()
            self.indicator.stop()
            self.networkActivityStop()
            self.animatePlacing(image: image, to: self.cardImageView)
            self.addTapZoomGesture(to: self.cardImageView)
        }) { (error) in
            if error?.code == Constants().noConnection {
                self.networkActivityStop()
                self.indicator.stop()
                self.cardImageView.image = UIImage.init(named: "cardBlur.png")
                self.addRefreshButton()
            } else {
                self.addNoSignImageView()
                self.networkActivityStop()
                self.indicator.stop()
            }
        }
    }
    // MARK: - Gestures
    private func addSwipeGesture() {
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestureAction))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
    }
    @objc private func swipeGestureAction() {
        self.navigationController?.popViewController(animated: true)
    }
    private func addTapZoomGesture(to cardImageView: UIImageView) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        cardImageView.addGestureRecognizer(tap)
    }
    @objc private func tapGestureAction() {
        let zoomVC = CardZoomVC.init(nibName: "CardZoomVC", bundle: nil)
        zoomVC.modalTransitionStyle = .crossDissolve
        zoomVC.modalPresentationStyle = .overFullScreen
        
        self.present(zoomVC, animated: true) {
            zoomVC.cardImageView.image = self.cardImageView.image
        }
    }
    // MARK: - No Sign Image View
    private func addNoSignImageView() {
        let noSignImageView = UIImageView.init(image: UIImage.init(named: "noImageSign.png"))
        noSignImageView.layer.shadowColor = UIColor.black.cgColor
        noSignImageView.layer.shadowRadius = 0.5
        noSignImageView.layer.shadowOpacity = 1.0
        noSignImageView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        noSignImageView.layer.masksToBounds = false
        cardImageView.addSubview(noSignImageView)
        addConstraints(view: noSignImageView)
    }
    // MARK: - Buttons
    private func setupBackButton() {
        let backButton = UIBarButtonItem.init(image: UIImage.init(named: "backButton.png"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
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
        cardImageView.addSubview(refreshButton!)
        addConstraints(view: refreshButton!)
    }
    @objc private func refreshButtonAction(_ sender: UIButton) {
        getImage()
    }
    @objc private func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Animations
    
    private func animatePlacing(image: UIImage, to cardImageView: UIImageView) {
        UIView.transition(with: cardImageView,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            cardImageView.image = image
        }, completion: nil)
    }
    // MARK: - Constraints
    private func addConstraints(view: UIView) {
        
        var multiplierHeight : CGFloat
        var multiplierWidth : CGFloat
        if let _ = view as? UIActivityIndicatorView {
            multiplierHeight = 0.2
            multiplierWidth = 0.4
        } else {
            multiplierHeight = 0.2
            multiplierWidth = 0.3
        }
        let centerX = NSLayoutConstraint.init(item: view, attribute: .centerX, relatedBy: .equal, toItem: cardImageView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint.init(item: view, attribute: .centerY, relatedBy: .equal, toItem: cardImageView, attribute: .centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: multiplierHeight, constant: 50)
        let width = NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: multiplierWidth, constant: 50)
        cardImageView.addConstraint(centerX)
        cardImageView.addConstraint(centerY)
        cardImageView.addConstraint(height)
        cardImageView.addConstraint(width)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    private func changeConstraints() {
        let screenHeight = Device(rawValue: UIScreen.main.bounds.size.height)!
        switch screenHeight {
        case .Iphone5:
            imageViewLeadingConstraint.constant = 85
            imageViewTrailingConstraint.constant = 85
            imageViewTopContraint.constant = 21
            bottomViewTopConstraint.constant = 35
            bottomViewBottomConstraint.constant = 35
        case .Iphone6_7:
            imageViewLeadingConstraint.constant = 90
            imageViewTrailingConstraint.constant = 90
            imageViewTopContraint.constant = 20
            bottomViewTopConstraint.constant = 35
            bottomViewBottomConstraint.constant = 35
        case .Iphone6_7_plus:
            navigationItem.title = "Card Details"
            topStackViewConstraint.constant = 80
            imageViewLeadingConstraint.constant = 120
            imageViewTrailingConstraint.constant = 120
            imageViewTopContraint.constant = 75
            bottomViewTopConstraint.constant = 35
            bottomViewBottomConstraint.constant = 45
        }
        self.view.updateConstraints()
    }
}
