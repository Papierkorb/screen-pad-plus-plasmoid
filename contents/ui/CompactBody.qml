/*
    SPDX-FileCopyrightText: 2023 Stefan Merettig <Stefan@Merettig.io>

    SPDX-License-Identifier: LGPL-3.0-or-later
*/

import QtQuick 2.3
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
    id: root
    signal expanded(bool isExpanded)

    PlasmaCore.IconItem {
        height: Plasmoid.configuration.iconSize
        width: Plasmoid.configuration.iconSize
        anchors.centerIn: parent

        source: root.Plasmoid.icon
        active: compactMouse.containsMouse

        MouseArea {
            id: compactMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                plasmoid.expanded = !plasmoid.expanded;
                root.expanded(plasmoid.expanded);
            }
        }
    }
}
