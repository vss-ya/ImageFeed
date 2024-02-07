//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by vs on 19.01.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
}

// MARK: - Actions
extension SingleImageViewController {
    
    @IBAction private func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func shareAction(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image ?? UIImage()],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
}

// MARK: - Helpers
extension SingleImageViewController {
    
    private func prepare() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
}
