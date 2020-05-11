//
//  DetailView.swift
//  MMPlayerView_Example
//
//  Created by Millman on 2020/1/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import AVFoundation
import MMPlayerView
@available(iOS 13.0.0, *)
struct DetailView: View {
    @EnvironmentObject var control: MMPlayerControl
    let obj: DataObj
    @State var downloadStatus: MMPlayerDownloader.DownloadStatus = .none
    @Binding var showDetailIdx: Int?
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                MMPlayerViewUI(control: control)
                Button.init(action: {
                    withAnimation {
                        self.showDetailIdx = nil
                    }
                }) {
                    Image("ic_keyboard_arrow_left").foregroundColor(Color.white)
                }
                .offset(x: 15, y: 44)
            }.frame(width: UIScreen.main.bounds.width,height: 200)
            .modifier(TransitionFramePreference())
            self.generateTopViewFromDownloadStatus().frame(height: 44)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(obj.title).font(.title).bold()
                    Text(obj.content).font(.body)
                }
            }
            .padding([.leading , .trailing], 8)
        }
        .modifier(MMPlayerDownloaderModifier( url: obj.play_Url!, status: $downloadStatus))
        .background(Color.white)
    }
    
    func generateTopViewFromDownloadStatus() -> AnyView {
        switch self.downloadStatus {
        case .none:
            let view = Button("Download") {
                MMPlayerDownloader.shared.download(asset: AVURLAsset(url: self.obj.play_Url!))
            }
            return AnyView.init(view)
        case .exist, .completed(_):
            let view = Button("Delete") {
                MMPlayerDownloader.shared.deleteVideo(self.obj.play_Url!)
            }
            return AnyView.init(view)
        case .downloading(let value):
            let percent = String.init(format: "%.2f ％", value*100)
            let view = ZStack {
                ProgressUI(barWidth: 200, barHeight: 16)
                .value(Double(value))
                Text(percent).foregroundColor(Color.white).frame(height: 10)
            }
            return AnyView(view)
        case .downloadWillStart:
            let view = ProgressUI(barWidth: 200, barHeight: 16)
                      .value(0.0)
            return AnyView(view)
        default:
            return AnyView(EmptyView())
        }
    }
}
#if DEBUG
@available(iOS 13.0.0, *)
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView.init(obj: DemoSource.shared.demoData[1], showDetailIdx: .constant(nil))
        .environmentObject(MMPlayerControl())

    }
}
#endif
