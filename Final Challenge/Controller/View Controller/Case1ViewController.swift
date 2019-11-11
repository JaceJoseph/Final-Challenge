//
//  Case1ViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 10/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class Case1ViewController: UIViewController {

    
    @IBOutlet var bendaTersedia: [UIView]!
    @IBOutlet var indikatorAngka: [UIImageView]!
    @IBOutlet weak var caseBackground: UIImageView!
    
    var posisiAwalBenda:[CGPoint] = []
    var urutanBenda:[Int]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for benda in bendaTersedia{
            addPanView(view: benda)
            let frame:CGRect = benda.frame
            posisiAwalBenda.append(frame.origin)
        }
        // Do any additional setup after loading the view.
    }
    
    func addPanView(view:UIView){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(Case1ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(sender:UIPanGestureRecognizer){
        let fileView = sender.view
        
        switch sender.state {
        case .began,.changed:
            moveViewWithPan(view: fileView!, sender: sender)
            
        case .ended:
            if (fileView?.frame.intersects(caseBackground.frame))! {
                if let editIndikatorIndex = fileView?.tag{
                    if indikatorAngka[editIndikatorIndex].isHidden == true{
                        indikatorAngka[editIndikatorIndex].isHidden = false
                        if urutanBenda.contains(editIndikatorIndex) == false{
                            urutanBenda.append(editIndikatorIndex)
                        }
                    }
                }
                returnViewToOrigin(view: fileView!)
                
            }else{
                returnViewToOrigin(view: fileView!)
            }
            
        default:
            return
        }
    }
    
    func moveViewWithPan(view:UIView,sender:UIPanGestureRecognizer){
        let translation = sender.translation(in:view)
        view.center = CGPoint(x: view.center.x+translation.x, y: view.center.y+translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func deleteView(view:UIView){
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0
        }
    }
    
    func returnViewToOrigin(view:UIView){
        UIView.animate(withDuration: 0.3) {
            view.frame.origin = self.posisiAwalBenda[view.tag]
        }
    }
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        print(urutanBenda)
        if urutanBenda.count == bendaTersedia.count{
            let kunciJawaban:[Int] = [2,1,0]
            var nilai = 0
            
            for index in kunciJawaban.indices{
                if kunciJawaban[index] == urutanBenda[index]{
                    nilai += 33
                }
            }
            if nilai == 99 {nilai = 100}
            print(nilai)
            //performSegue(withIdentifier: "testSegue", sender: self)
        }else{
            print("Not yet")
        }
        self.performSegue(withIdentifier: "nextContainer", sender: self)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        for indikator in indikatorAngka {
            indikator.isHidden = true
        }
        
        urutanBenda.removeAll()
    }
}
