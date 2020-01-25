import BootstrapKit

struct LogoImage: HTMLComponent {

    let isDark: Conditionable
    let rootUrl: String

    init(rootUrl: String = "", isDark: Conditionable = true) {
        self.rootUrl = rootUrl
        self.isDark = isDark
    }

    var body: HTML {
        IF(isDark) {
            Img().source(rootUrl + "/assets/images/logo-dark.png").alt("Logo").height(30)
        }.else {
            Img().source(rootUrl + "/assets/images/logo.png").alt("Logo").height(30)
        }
    }
}
