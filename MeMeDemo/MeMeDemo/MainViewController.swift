//
//  MainViewController.swift
//  MeMeDemo
//
//  Created by fabo on 2021/3/4.
//

import UIKit
import MeMeTwitter

class MainViewController: UIViewController {
    
    @IBOutlet var statusLabel:UILabel?
    @IBOutlet var shareLabel:UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusLabel?.text = "未登陆"
        shareLabel?.text = "未分享"
    }

    @IBAction func loginClicked(sender:UIButton?) {
        MeMeTwitter.shared.logIn(with: self) { [weak self] (token, error) in
            if error == nil {
                self?.statusLabel?.text = "已登录:\(token?.screenName ?? "")"
            }else {
                self?.statusLabel?.text = "登录失败"
            }
        }
    }
    
    @IBAction func shareClicked(sender:UIButton?) {
        let data = MeMeTwitterShareData()
        data.text = "11111"
        MeMeTwitter.shared.share(with: self, data: data) { [weak self] (stage,ret)  in
            if stage == .end {
                if ret == true {
                    self?.shareLabel?.text = "分享成功"
                }else{
                    self?.shareLabel?.text = "分享失败"
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
