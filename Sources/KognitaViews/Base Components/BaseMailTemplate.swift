import BootstrapKit

struct FavIcon: HTMLComponent {

    let url: String

    var body: HTML {
        Link().relationship(.shortcutIcon).href(url)
    }
}

struct Viewport: HTMLComponent {

    enum WidthMode {
        case acordingToDevice
        case constant(Int)

        var width: String {
            switch self {
            case .acordingToDevice: return "device-width"
            case .constant(let width): return "\(width)"
            }
        }
    }

    var mode: WidthMode
    var internalScale: Double = 1

    var body: HTML {
        Meta().name(.viewport).content("width=\(mode.width), initial-scale=\(internalScale)")
    }
}

struct MailTemplate: HTMLComponent {

    let rootUrl: String
    var stylesheetUrl: String { rootUrl + "/assets/css/app.min.css" }
    var iconsUrl: String { rootUrl + "/assets/css/icons.min.css" }
    var faviconUrl: String { rootUrl + "/assets/images/favicon.ico" }

    let title: TemplateValue<String>
    let description: TemplateValue<String>
    let content: HTML

    init(rootUrl: String, title: TemplateValue<String>, description: TemplateValue<String>, @HTMLBuilder body: () -> HTML) {
        self.rootUrl = rootUrl
        self.title = title
        self.description = description
        self.content = body()
    }

    var body: HTML {
        Document(type: .html5) {
            Head {
                Viewport(mode: .acordingToDevice)

                Title { title }
                Description { description }
                Author { "Kognita" }

                Stylesheet(url: stylesheetUrl)
                Stylesheet(url: iconsUrl)
                FavIcon(url: faviconUrl)
            }
            Body {
                Div {
                    Container {
                        Row {
                            Div {
                                Div {
                                    Div {
                                        Anchor {
                                            Span {
                                                LogoImage(rootUrl: rootUrl)
                                            }
                                        }
                                        .href(rootUrl)
                                    }
                                    .class("card-header")
                                    .padding(.four, for: .top)
                                    .padding(.four, for: .bottom)
                                    .text(alignment: .center)
                                    .background(color: .primary)

                                    Div {
                                        content
                                    }
                                    .class("card-body")
                                    .padding(.four)
                                }
                                .class("card")
                            }
                            .column(width: .five, for: .large)
                        }
                        .horizontal(alignment: .center)
                    }
                }
                .margin(.five, for: .top)
                .margin(.five, for: .bottom)
                .class("account-pages")
            }
        }
    }
}
