//
//  ContentView.swift
//  VideoPlayerSwiftUI
//
//  Created by Michael Gauthier on 2021-01-06.
//

import SwiftUI
import AVKit

struct ContentView: View {
    //Variables
    @State var player = AVPlayer(url:URL(string: "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4")!)
    @State var isplaying = false
    @State var showcontrols = false
    
    var body: some View {
//View for Player & Content
        VStack{
            ZStack{
                VideoPlayer(player: $player)
                if self.showcontrols{
                    Controls(player: self.$player, isplaying: self.$isplaying, pannel: self.$showcontrols)
                }
            }
            .frame(height: UIScreen.main.bounds.height/3.5)
            .onTapGesture {
                self.showcontrols = true
            }
            
            GeometryReader{geo in
                VStack(){
                    ScrollView(.vertical){
                    Text("Test Text").foregroundColor(.white)
                    }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
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
