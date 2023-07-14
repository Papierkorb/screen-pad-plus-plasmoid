/*
    SPDX-FileCopyrightText: 2023 Stefan Merettig <Stefan@Merettig.io>

    SPDX-License-Identifier: LGPL-3.0-or-later
*/

import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15 as QtControls

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root

    readonly property string constBRIGHTNNESS_FILE: "/sys/class/leds/asus::screenpad/brightness"
    property DialogBody dialogBody: null
    property bool muteBrightnessSignals: false

    Plasmoid.compactRepresentation: CompactBody {
        onExpanded: {
            if (isExpanded) readCurrentBrightness();
        }
    }

    Plasmoid.fullRepresentation: DialogBody {
        id: dialogBody
        onModeChanged: updateBrightness(dialogBody.mode, dialogBody.brightness);
        onBrightnessChanged: updateBrightness(dialogBody.mode, dialogBody.brightness);

        Component.onCompleted: {
            root.dialogBody = dialogBody;
            readCurrentBrightness();
        }
    }

    Plasmoid.toolTipMainText: i18n("Screen Pad+")
    Plasmoid.toolTipSubText: dialogBody.mode == 0 ? i18n("Display is turned off") : dialogBody.mode == 1 ? i18n("Display is active, but blind") : i18n("Display is active")
    Plasmoid.icon: Qt.resolvedUrl("./image/icon.svg")
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    PlasmaCore.DataSource {
        id: commandExecutor
        engine: "executable"
        connectedSources: []

        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]

            exited(exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }

        function exec(cmd) { connectSource(cmd) }

        signal exited(int exitCode, int exitStatus, string stdout, string stderr)
    }

    Connections {
        id: readBrightnessConnection
        target: null
        function onExited(exitCode_, exitStatus_, stdout, stderr_) {
            readCurrentBrightness2nd(stdout);
        }
    }

    function updateBrightness(mode, brightness) {
        if (root.muteBrightnessSignals) return;

        let value = 0;
        if (mode == 1) value = 1;
        else if (mode == 2) value = parseInt(brightness);

        // Write to file
        commandExecutor.exec("echo " + value + " > " + constBRIGHTNNESS_FILE);
    }

    function readCurrentBrightness() {
        root.muteBrightnessSignals = true;
        readBrightnessConnection.target = commandExecutor;
        commandExecutor.exec("cat " + constBRIGHTNNESS_FILE);
    }

    function readCurrentBrightness2nd(stdout) {
        readBrightnessConnection.target = null;

        const value = parseInt(stdout);
        let mode = 0;
        let brightness = 0;

        if (value == 0 || value == 1) {
            mode = value;
            brightness = 128.0;
        } else {
            mode = 2;
            brightness = value;
        }

        dialogBody.mode = mode;
        dialogBody.brightness = brightness;
        root.muteBrightnessSignals = false;
    }
}
