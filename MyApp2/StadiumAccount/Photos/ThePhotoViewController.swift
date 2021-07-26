//
//  ThePhotoViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 16.07.2021.
//

import UIKit
import ImageSlideshow

class ThePhotoViewController: UIViewController {
    
    var selectedPhoto=""
    var image=""
    var imageArray=[String]()
    var inputAray=[KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for image in imageArray {
            inputAray.append(KingfisherSource(urlString: image)!)
        }
        // Do any additional setup after loading the view.
        let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width*0.95, height: self.view.frame.height*0.9))
        imageSlideShow.backgroundColor=UIColor.white
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor=UIColor.lightGray
        pageIndicator.pageIndicatorTintColor=UIColor.black
        imageSlideShow.pageIndicator=pageIndicator
        
        imageSlideShow.contentScaleMode=UIViewContentMode.scaleAspectFit
        imageSlideShow.setImageInputs(inputAray)
        self.view.addSubview(imageSlideShow)
    }
    
}
