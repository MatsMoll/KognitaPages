//
//  QTIImportButton.swift
//  KognitaViews
//
//  Created by Mats Mollestad on 03/09/2020.
//

import BootstrapKit

struct QTIImportButton: HTMLComponent {

    var body: HTML {
        Form {
            Text { "Importer QTI" }
            Input(type: .file, id: "files")
                .add(.init(attribute: "multiple", value: "multiple"))
                .name("files")
                .button(style: .info)

            Button { "Importer" }
                .type(.button)
                .on(click: "importFiles()")
                .button(style: .primary)
        }
    }

    var scripts: HTML {
        Script {
"""
function importFiles() {
var fd = new FormData();
var ins = document.getElementById('files').files.length;
for (var x = 0; x < ins; x++) {
fd.append("files[]", document.getElementById('files').files[x]);
}
var xhr = new XMLHttpRequest();
xhr.open("POST", "import-qti");
xhr.send();
}
"""
        }
    }
}
