/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1


IOSPage
{
    width: parent.width
    height: parent.height

    signal refresh();

    Column
    {
        anchors.fill: parent;

        Rectangle
        {
            width: parent.width
            height: Theme.statusBarHeight
        }

        ToolBarItem
        {
            width: parent.width
            height: 42 * fudge
        }

        TabView
        {
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            style: touchStyle

            Tab
            {
                title: "Info"

                FilterInfo {}
            }
        }

        Component {
            id: touchStyle
            TabViewStyle {
                tabsAlignment: Qt.AlignVCenter
                tabOverlap: 0
                frame: Item { }
                tab: Item {
                    implicitWidth: control.width/control.count
                    implicitHeight: 50 * fudge
                    BorderImage {
                        anchors.fill: parent
                        border.bottom: 8 * fudge
                        border.top: 8 * fudge
                        source: styleData.selected ? "qrc:/qml/images/tab_selected.png":"../images/tabs_standard.png"
                        Text {
                            anchors.centerIn: parent
                            color: "white"
                            text: styleData.title.toUpperCase()
                            font.pixelSize: 12 * fudge
                            font.family: "FontAwesome"
                        }
                        Rectangle {
                            visible: index > 0
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.margins: 10 * fudge
                            width:1
                            color: "#3a3a3a"
                        }
                    }
                }
            }
        }
    }

    Component.onDestruction:
    {
        refresh();
    }
}
