import BootstrapKit


struct MaterialDesignIcon: HTMLComponent, AttributeNode {
    enum Icons: String {
        case infinity
        case check
        case checkAll = "check-all"
        case minus
        case eye
        case close
        case save
        case delete
        case avTime = "av-time"
        case cameraTime = "camera-time"
        case timerSand = "timer-sand"
        case timerSandFull = "timer-sand-full"
        case timerSandEmpty = "timer-sand-empty"
        case timer
        case timerOff = "timer-off"
        case teach
        case emoticonExcited = "emoticon-excited"
        case trophy
        case trophyAwared = "trophy-awared"
        case trophyOutline = "trophy-outline"
        case star
        case starOutline = "star-outline"
        case chevronDown = "chevron-down"
        case arrowLeft = "arrow-left"
        case arrowRight = "arrow-right"
        case accountCircle = "account-circle"
        case formatListBulleted = "format-list-bulleted"
        case viewList = "view-list"
        case history
    }

    let icon: TemplateValue<Icons>
    var attributes: [HTMLAttribute]

    init(icon: Icons) {
        self.icon = .constant(icon)
        self.attributes = []
    }

    init(icon: TemplateValue<Icons>) {
        self.icon = icon
        self.attributes = []
    }

    init(_ icon: Icons) {
        self.icon = .constant(icon)
        self.attributes = []
    }

    init(_ icon: TemplateValue<Icons>) {
        self.icon = icon
        self.attributes = []
    }

    private init(icon: TemplateValue<Icons>, attributes: [HTMLAttribute]) {
        self.icon = icon
        self.attributes = attributes
    }

    func copy(with attributes: [HTMLAttribute]) -> MaterialDesignIcon {
        .init(icon: icon, attributes: attributes)
    }

    var body: HTML {
        Italic().class("mdi mdi-" + icon.rawValue)
    }
}
