//
//  MainController.swift
//  Radio
//
//  Created by Andrii on 16.12.2021.
//

import UIKit
import SwiftSoup
import AVKit
import AlamofireImage

class MainController: BaseViewController {
    
    var stations = [Station]()
    
    let player = AVPlayer()
    var playerLayer: AVPlayerLayer!

    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 80
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        setupLayout()
        
        let htmlFile = Bundle.main.path(forResource: "StationsList", ofType: "html")
        let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)

        
        guard let doc: Document = try? SwiftSoup.parse(htmlString!),
              let list = try? doc.select("[class~=(?i)stations__station]")
        else {
            return
        }
            
        list.forEach { item in
            let text = item.description
                        
            guard
                let regex = try? NSRegularExpression(pattern: "([^ =,]*)=(\"[^\"]*\"|[^,\"]*)", options: [.caseInsensitive])
            else {
                return
            }
            let matches  = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
            
            var resultString = ""
            
            matches.forEach { match in
                let keyRange =  match.range(at: 1)
                let valueRange =  match.range(at: 2)
                
                if let substringKeyRange = Range(keyRange, in: text), let substringValueRange = Range(valueRange, in: text) {
                    if !resultString.isEmpty {
                        resultString.append(", ")
                    }
                    
                    let key = "\"\(String(text[substringKeyRange]))\""
                    let value = String(text[substringValueRange])

                    resultString.append(key + ":" + value)
                }
            }
            
            let jsonString = "{\(resultString)}"

            guard
                let data = jsonString.data(using: .utf8),
                let station = try? JSONDecoder().decode(Station.self, from: data)
            else { return }
            
            stations.append(station)
        }
        print(stations)
        tableView.reloadData()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let station = stations[indexPath.row]
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "Cell")
        cell.imageView?.af.setImage(withURL: URL(string: "https:\(station.imageUrl)")!)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.backgroundColor = .black
        cell.textLabel?.text = station.name
        cell.detailTextLabel?.text = station.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]

        let asset = AVAsset(url: URL(string: station.stream)!)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        player.replaceCurrentItem(with: playerItem)
        
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspect
        
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.imageView?.af.cancelImageRequest()
    }
}
