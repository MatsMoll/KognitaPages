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

                Button {
                    "Jeg godtar"
                    MaterialDesignIcon(.check)
                        .margin(.one, for: .left)
                }
                .on(click: "cookiesConfirmed()")
                .button(style: .primary)
                .float(.right)
                .margin(.two, for: .left)

                Text { "For å se din personlig data på Kognita må vi bruke cookies. Heldigvis blir cookien din privat hos oss. Ved å trykke på \"Jeg godtar\" eller ved å logge inn, så godtar du denne bruken." }
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
