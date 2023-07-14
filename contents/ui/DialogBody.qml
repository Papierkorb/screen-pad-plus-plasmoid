/*
    SPDX-FileCopyrightText: 2023 Stefan Merettig <Stefan@Merettig.io>

    SPDX-License-Identifier: LGPL-3.0-or-later
*/

import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15 as QtControls

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root
    property int mode: 0
    property alias brightness: slider.value

    Layout.preferredWidth: 280 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 100 * PlasmaCore.Units.devicePixelRatio

    ColumnLayout {
        anchors.centerIn: parent
        anchors.margins: Kirigami.Units.gridUnit

        spacing: Kirigami.Units.gridUnit

        Row {
            Layout.alignment: Qt.AlignCenter

            PlasmaComponents.Button {
                readonly property int mode: 0

                QtControls.ButtonGroup.group: stateButtonGroup
                text: i18n("Disabled")
                checked: root.mode == 0
                checkable: true
            }
            PlasmaComponents.Button {
                readonly property int mode: 1

                QtControls.ButtonGroup.group: stateButtonGroup
                text: i18n("Blind")
                checked: root.mode == 1
                checkable: true
            }
            PlasmaComponents.Button {
                readonly property int mode: 2

                QtControls.ButtonGroup.group: stateButtonGroup
                text: i18n("Active")
                checked: root.mode == 2
                checkable: true
            }
        }

        Row {
            Layout.alignment: Qt.AlignCenter
            spacing: 8

            PlasmaComponents.Slider {
                id: slider
                from: 10.0
                to: 255.0
                value: 128.0 // TODO: Read initially
                live: true
                enabled: mode == 2
            }

            PlasmaComponents.Label {
                id: sliderLabel
                text: Math.round(slider.value / 255.0 * 100.0) + "%";
            }
        }
    }

    QtControls.ButtonGroup {
        id: stateButtonGroup
        exclusive: true

        onClicked: {
            mode = button.mode;
        }
    }
}
