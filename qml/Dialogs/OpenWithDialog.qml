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
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import LongUI 1.0 as LongUI

Item {
    id: control

    property string url: main.url

    width: 400 + LongUI.Units.largeSpacing * 2
    height: _mainLayout.implicitHeight + LongUI.Units.largeSpacing * 2

    Rectangle {
        anchors.fill: parent
        color: LongUI.Theme.secondBackgroundColor
    }

    Component.onCompleted: {
        var items = mimeAppManager.recommendedApps(control.url)

        for (var i in items) {
            listView.model.append(items[i])
        }

        defaultCheckBox.checked = false
        doneButton.focus = true
    }

    function openApp() {
        if (defaultCheckBox.checked)
            mimeAppManager.setDefaultAppForFile(control.url, listView.model.get(listView.currentIndex).desktopFile)

        launcher.launchApp(listView.model.get(listView.currentIndex).desktopFile, control.url)
        main.close()
    }

    Keys.enabled: true
    Keys.onEscapePressed: main.close()

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        spacing: 0

        GridView {
            id: listView
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            model: ListModel {}
            clip: true
            ScrollBar.vertical: ScrollBar {}

            leftMargin: LongUI.Units.smallSpacing
            rightMargin: LongUI.Units.smallSpacing

            cellHeight: {
                var extraHeight = calcExtraSpacing(80, listView.Layout.preferredHeight - topMargin - bottomMargin)
                return 80 + extraHeight
            }

            cellWidth: {
                var extraWidth = calcExtraSpacing(120, listView.width - leftMargin - rightMargin)
                return 120 + extraWidth
            }

            Label {
                anchors.centerIn: parent
                text: qsTr("No applications")
                visible: listView.count === 0
            }

            delegate: Item {
                id: item
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                scale: mouseArea.pressed ? 0.95 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }

                property bool isSelected: listView.currentIndex === index

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    onDoubleClicked: control.openApp()
                    onClicked: listView.currentIndex = index
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: LongUI.Units.smallSpacing
                    radius: LongUI.Theme.mediumRadius
                    color: isSelected ? LongUI.Theme.highlightColor
                                      : mouseArea.containsMouse ? Qt.rgba(LongUI.Theme.textColor.r,
                                                                          LongUI.Theme.textColor.g,
                                                                          LongUI.Theme.textColor.b,
                                                                          0.1) : "transparent"
                    smooth: true
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: LongUI.Units.smallSpacing
                    spacing: LongUI.Units.smallSpacing

                    LongUI.IconItem {
                        id: icon
                        Layout.preferredHeight: 36
                        Layout.preferredWidth: height
                        source: model.icon
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        text: model.name
                        Layout.fillWidth: true
                        elide: Text.ElideMiddle
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Qt.AlignHCenter
                        color: isSelected ? LongUI.Theme.highlightedTextColor : LongUI.Theme.textColor
                    }
                }
            }
        }

        CheckBox {
            id: defaultCheckBox
            focusPolicy: Qt.NoFocus
            text: qsTr("Set as default")
            enabled: listView.count >= 1
            padding: 0

            Layout.leftMargin: LongUI.Units.largeSpacing
            Layout.bottomMargin: LongUI.Units.largeSpacing
        }

        RowLayout {
            spacing: LongUI.Units.largeSpacing
            Layout.leftMargin: LongUI.Units.largeSpacing
            Layout.rightMargin: LongUI.Units.largeSpacing
            Layout.bottomMargin: LongUI.Units.largeSpacing

            Button {
                text: qsTr("Cancel")
                Layout.fillWidth: true
                onClicked: main.close()
            }

            Button {
                id: doneButton
                focus: true
                flat: true
                text: qsTr("Open")
                enabled: listView.count > 0
                Layout.fillWidth: true
                onClicked: control.openApp()
            }

        }
    }

    function calcExtraSpacing(cellSize, containerSize) {
        var availableColumns = Math.floor(containerSize / cellSize)
        var extraSpacing = 0
        if (availableColumns > 0) {
            var allColumnSize = availableColumns * cellSize
            var extraSpace = Math.max(containerSize - allColumnSize, 0)
            extraSpacing = extraSpace / availableColumns
        }
        return Math.floor(extraSpacing)
    }
}
