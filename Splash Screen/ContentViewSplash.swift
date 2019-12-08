

import SwiftUI
import MapKit

struct ContentViewSplash: View {
  @State var showSplash = true
        
    var body: some View {
      ZStack{
        if showSplash {
            SplashScreen()
            .opacity(showSplash ? 1 : 0)
            .onAppear {
                         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                           SplashScreen.shouldAnimate = false
                           withAnimation() {
                             self.showSplash = false
                           }
                         }
                     }
        } else {
        ContentView()
    }
        }
  }
}

#if DEBUG
struct ContentViewSplash_Previews: PreviewProvider {
  static var previews: some View {
    ContentViewSplash()
  }
}
#endif
