/*
 * Copyright (C) 2023 LongOS Team.
 *
 * Author:     chang2005 <389574063@qq.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import LongUI 1.0 as LongUI

Window {
    id: control

    title: qsTr("New folder name")
    flags: Qt.Dialog
    visible: true

    width: 400 + LongUI.Units.largeSpacing * 2
    height: _mainLayout.implicitHeight + LongUI.Units.largeSpacing * 2

    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height

    Rectangle {
        anchors.fill: parent
        color: LongUI.Theme.secondBackgroundColor
    }

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.margins: LongUI.Units.largeSpacing
        spacing: LongUI.Units.largeSpacing

        LongUI.ActionTextField {
            id: _textField
            Layout.fillWidth: true
            Keys.onEscapePressed: control.close()
            text: qsTr("New folder")
            focus: true

            onAccepted: {
                main.newFolder(_textField.text)
                control.close()
            }

            Component.onCompleted: {
                _textField.selectAll()
            }
            
            rightActions: [
                Action {
                    icon.source: "image://icontheme/edit-clear"
                    onTriggered: {
                        _textField.text = ""
                    }
                }
            ]
        }

        RowLayout {
            spacing: LongUI.Units.largeSpacing

            Button {
                text: qsTr("Cancel")
                Layout.fillWidth: true
                onClicked: control.close()
            }

            Button {
                text: qsTr("OK")
                Layout.fillWidth: true
                onClicked: {
                    main.newFolder(_textField.text)
                    control.close()
                }
                enabled: _textField.text
                flat: true
            }
        }
    }
}
