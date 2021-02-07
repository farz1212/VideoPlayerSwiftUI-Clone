//
//  ContentView.swift
//  VideoPlayerSwiftUI
//
//  Created by Michael Gauthier on 2021-01-06.
//

import SwiftUI
import AVKit
import Alamofire
import SwiftyJSON

struct ContentView: View {
//Variables
    let url = "http://localhost:4000/videos"
    @State var player = AVPlayer(url:URL(string:"https://d140vvwqovffrf.cloudfront.net/media/5e87b9a811599/hls/index.m3u8")!)
    
    @State var isplaying = false
    @State var showcontrols = false
    
//Create object to append data to jsondata
    @ObservedObject var obs = values()
    
//View for Player & Content
    var body: some View {
        VStack{
            
            ZStack{
                VideoPlayer(player: $player)
                if self.showcontrols{
                    Controls(player: self.$player, isplaying: self.$isplaying, pannel: self.$showcontrols)
                }
            }
            .frame(height: UIScreen.main.bounds.height/3)
            .onTapGesture {
                self.showcontrols = true
            }
            
            GeometryReader{geo in
                VStack(){
                    
//ScrollView for Description
                    ScrollView(.vertical){
                        Text("Title").foregroundColor(.white).bold()
                        Spacer()
                        Text("Author").foregroundColor(.white).bold()
                        Spacer()
                        Text(obs.jsondata.description).foregroundColor(.white)
                            
                   
                    }.frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
            }
            }
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear(){
            //self.player.play()
            self.isplaying = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//View for Controls
struct Controls : View{
    
    @Binding var player : AVPlayer
    @Binding var isplaying : Bool
    @Binding var pannel : Bool
    var body : some View{
        VStack{
            Spacer()
            HStack{
//Previous Button
                Button(action: {
                    
//To go to previous video
                }){
                    Image(uiImage: UIImage(named: "previous")!).font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
                
//Play&Pause Button
                Button(action: {
                    if self.isplaying{
                        self.player.pause()
                        self.isplaying = false
                    }
                    else{
                        self.player.play()
                        self.isplaying = true
                    }
                }){
//Switch for Play & Pause
                    Image(uiImage: UIImage(named: self.isplaying ? "pause": "play")!).font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
//Next Button
                Button(action: {
                    
//To go to next video
                }){
                    Image(uiImage: UIImage(named: "next")!).font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
            }
            Spacer()
            
        }.padding()
        .background(Color.black.opacity(0.4))
        .onTapGesture {
            self.pannel = false
        }
    }
}

//Video Player
struct VideoPlayer : UIViewControllerRepresentable {
    
    @Binding var player : AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
        
        
    }
}
//JSON and Alimofire code to parse data
class values: ObservableObject{
    @Published var jsondata = [initialize]()
    init(){
        Alamofire.request("http://localhost:4000/videos").responseData{
            (data) in
            let json = try! JSON(data:data.data!)
            for i in json{
                print(i.1["description"])
                
                self.jsondata.append(initialize(id: i.1["id"].intValue, description: i.1["description"].stringValue))
            }
        }
    }
}

//Structure for recieved data
struct initialize: Identifiable, Decodable{
    var id: Int
    var description: String
}
