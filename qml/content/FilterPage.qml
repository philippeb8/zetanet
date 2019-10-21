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

    property alias range: range.value

    signal refresh();

    Column
    {
        anchors.fill: parent;

        Rectangle
        {
            width: parent.width
            height: Theme.statusBarHeight
        }

        DoneToolBarItem
        {
            width: parent.width
            height: 42 * fudge
        }

        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width
            spacing: 8 * fudge

            Text {
                text: "Gender"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ExclusiveGroup { id: genderGroup }
            RadioButton {
                text: "Male"
                checked: true
                exclusiveGroup: genderGroup
                style: radioButtonStyle
                anchors.horizontalCenter: parent.horizontalCenter
            }
            RadioButton {
                text: "Female"
                checked: true
                exclusiveGroup: genderGroup
                style: radioButtonStyle
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text
            {
                text: "Range (miles)"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Slider
            {
                id: range
                anchors.margins: 20
                style: sliderStyle
                minimumValue : 20000
                maximumValue : 200000
                anchors.horizontalCenter: parent.horizontalCenter

                onValueChanged:
                {
                    sliderText.text = "(" + Math.round(value / 10) / 100 + " km)"
                }

                Component.onCompleted:
                {
                    sliderText.text = "(" + Math.round(value / 10) / 100 + " km)"
                }

                Component.onDestruction:
                {
                    distance = value;
                    refresh();
                }
            }

            Text
            {
                id: sliderText
                text: "(0 km)"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Component {
            id: buttonStyle
            ButtonStyle {
                panel: Item {
                    implicitHeight: 50 * fudge
                    implicitWidth: 320 * fudge
                    BorderImage {
                        anchors.fill: parent
                        antialiasing: true
                        border.bottom: 8
                        border.top: 8
                        border.left: 8
                        border.right: 8
                        anchors.margins: control.pressed ? -4 : 0
                        source: control.pressed ? "qrc:/qml/images/button_pressed.png" : "qrc:/qml/images/button_default.png"
                        Text {
                            text: control.text
                            anchors.centerIn: parent
                            color: "black"
                            font.pixelSize: 16 * fudge
                            renderType: Text.NativeRendering
                        }
                    }
                }
            }
        }

        Component {
            id: radioButtonStyle
            RadioButtonStyle {
                label: Item {
                    implicitHeight: 30 * fudge
                    implicitWidth: 100 * fudge
                    Text {
                        text: control.text
                        anchors.verticalCenter: parent.verticalCenter
                        color: "black"
                        font.pixelSize: 16 * fudge
                        renderType: Text.NativeRendering
                    }
                }
            }
        }

        Component {
            id: switchStyle
            SwitchStyle {

                groove: Rectangle {
                    implicitHeight: 30 * fudge
                    implicitWidth: 152 * fudge
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: parent.width/2 - 40 * fudge
                        height: 20 * fudge
                        anchors.margins: 2
                        color: control.checked ? "#468bb7" : "#222"
                        Behavior on color {ColorAnimation {}}
                        Text {
                            font.pixelSize: 16 * fudge
                            color: "black"
                            anchors.centerIn: parent
                            text: "ON"
                        }
                    }
                    Item {
                        width: parent.width/2
                        height: parent.height
                        anchors.right: parent.right
                        Text {
                            font.pixelSize: 16 * fudge
                            color: "black"
                            anchors.centerIn: parent
                            text: "OFF"
                        }
                    }
                    color: "#222"
                    border.color: "#444"
                    border.width: 2
                }
                handle: Rectangle {
                    width: parent.parent.width/2
                    height: control.height
                    color: "#444"
                    border.color: "#555"
                    border.width: 2
                }
            }
        }

        Component {
            id: sliderStyle
            SliderStyle {
                handle: Rectangle {
                    width: 30 * fudge
                    height: 30 * fudge
                    radius: height
                    antialiasing: true
                    color: Qt.lighter("#468bb7", 1.2)
                }

                groove: Item {
                    implicitHeight: 30 * fudge
                    implicitWidth: 200 * fudge
                    Rectangle {
                        height: 8 * fudge
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#444"
                        opacity: 0.8
                        Rectangle {
                            antialiasing: true
                            radius: 1
                            color: "#468bb7"
                            height: parent.height
                            width: parent.width * control.value / control.maximumValue
                        }
                    }
                }
            }
        }
    }
}
