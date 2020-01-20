import BootstrapKit

struct NodeList: HTMLComponent {

    let body: HTML

    init(@HTMLBuilder list: () -> HTML) {
        self.body = list()
    }
}
