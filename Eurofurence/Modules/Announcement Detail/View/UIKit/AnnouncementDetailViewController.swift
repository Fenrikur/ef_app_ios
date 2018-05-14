//
//  AnnouncementDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class AnnouncementDetailViewController: UITableViewController, AnnouncementDetailScene {

    // MARK: IBOutlets

    @IBOutlet weak var announcementHeadingLabel: UILabel!
    @IBOutlet weak var announcementContentsTextView: UITextView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        announcementContentsTextView.textContainer.lineFragmentPadding = 0
        delegate?.announcementDetailSceneDidLoad()
    }

    // MARK: AnnouncementDetailScene

    private var delegate: AnnouncementDetailSceneDelegate?
    func setDelegate(_ delegate: AnnouncementDetailSceneDelegate) {
        self.delegate = delegate
    }

    func setAnnouncementTitle(_ title: String) {
        super.title = title
    }

    func setAnnouncementHeading(_ heading: String) {
        announcementHeadingLabel.text = heading
    }

    func setAnnouncementContents(_ contents: NSAttributedString) {
        announcementContentsTextView.attributedText = contents
    }

}