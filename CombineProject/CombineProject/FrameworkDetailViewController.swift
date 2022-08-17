//
//  FrameworkDetailViewController.swift
//  AppleFramework
//
//  Created by joonwon lee on 2022/05/01.
//

import UIKit
import SafariServices
import Combine

class FrameworkDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
   @Published var framework: AppleFramework = AppleFramework(name: "Unknown", imageName: "", urlString: "", description: "")
    var subscription = Set<AnyCancellable>()
    let buttonTapped = PassthroughSubject<AppleFramework,Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    private func bind(){
        // input
        buttonTapped
            .receive(on: RunLoop.main)
            .compactMap { URL(string: $0.urlString)}
            .sink { [self] url in
                let safari = SFSafariViewController(url: url)
                present(safari, animated: true)
            }.store(in: &subscription)
        // output
        $framework
            .receive(on: RunLoop.main)
            .sink { [unowned self] framwork in
                self.imageView.image = UIImage(named: framework.imageName)
                self.titleLabel.text = framework.name
                self.descriptionLabel.text = framework.description
            }.store(in: &subscription)
    }
    @IBAction func learnMoreTapped(_ sender: Any) {
        buttonTapped.send(framework)
    }
}
