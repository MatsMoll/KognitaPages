//
//  CookieMessage.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 27/09/2020.
//

import BootstrapKit

struct CookieMessage: HTMLComponent {

    let id = "cookie-footer"

    var scripts: HTML {
        NodeList {
            body.scripts
            Script {
"""
function cookiesConfirmed() {
$('#cookie-footer').hide(); var d = new Date();
d.setTime(d.getTime() + (365*24*60*60*1000)); var expires = "expires="+ d.toUTCString();
document.cookie = "cookies-accepted=true;" + expires;
$("body").css("padding-bottom", "");
$("body").addClass("pb-0");
}

$(document).ready(function () {
$("body").removeClass("pb-0");
$("body").css("padding-bottom", $("#\(id)").height());
})
"""
            }
        }
    }

    var body: HTML {
        Alert {
            Container {
                Text { "Vi bruker cookies" }
                    .style(.lead)
                    .text(color: .dark)

                Button { "Jeg godtar" }
                    .on(click: "cookiesConfirmed()")
                    .button(style: .primary)
                    .float(.right)

                Text { "For å bruke denne siden trenger vi å bruke cookies så du kan vise din egen data. Heldigvis bruker vi ikke cookien din til noe annet. Derfor godtar du bruken av cookies ved å logge inn." }
            }
            .padding(.one, for: .top)
        }
        .id(id)
        .class("fixed-bottom")
        .isDismissable(false)
        .background(color: .light)
        .margin(.zero, for: .bottom)
    }
}
