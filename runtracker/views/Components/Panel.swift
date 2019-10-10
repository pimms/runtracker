import SwiftUI

struct Panel<Content> : View where Content : View {
    private let title: String
    private let content: Content

    init(title: String, content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text(title).padding().font(.headline)
                Spacer()
            }

            Group {
                content
            }.padding([.leading, .bottom, .trailing])
        }.border(Color.gray).cornerRadius(5)
    }
}

#if DEBUG
struct Panel_Previews: PreviewProvider {
    static var previews: some View {
        Panel(title: "panel") {
            ZStack {
                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(.gray)
                Text("Content area!")
                    .foregroundColor(.white)
            }
        }
    }
}
#endif
