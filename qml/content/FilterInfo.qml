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

    Column
    {
        anchors.fill: parent;

        width: parent.width
        spacing: 8 * fudge

        Text
        {
            id: sliderText
            text: "Range"
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
                sliderText.text = "Range (" + Math.round(value / 10) / 100 + " km)"
            }

            Component.onCompleted:
            {
                sliderText.text = "Range (" + Math.round(value / 10) / 100 + " km)"
            }

            Component.onDestruction:
            {
                distance = value;
            }
        }

        Text
        {
            text: "Gender"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ExclusiveGroup { id: genderGroup }
        RadioButton
        {
            id: genderMale
            text: "Male"
            exclusiveGroup: genderGroup
            style: radioButtonStyle
            anchors.horizontalCenter: parent.horizontalCenter
        }
        RadioButton
        {
            id: genderFemale
            text: "Female"
            exclusiveGroup: genderGroup
            style: radioButtonStyle
            anchors.horizontalCenter: parent.horizontalCenter
        }

        CheckBoxItem
        {
            id: gendershow
            width: parent.width
            //height: 42 * fudge

            text: "Any Gender"
            image: false
        }

        Text
        {
            text: "Minimum Date of Birth"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter

            SpinBox
            {
                id: dobmm
                value: 1
                minimumValue: 1
                maximumValue: 12
                font.pixelSize: 20 * fudge
            }
            Text
            {
                text: "/"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
            }
            SpinBox
            {
                id: dobdd
                value: 1
                minimumValue: 1
                maximumValue: 31
                font.pixelSize: 20 * fudge
            }
            Text
            {
                text: "/"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
            }
            SpinBox
            {
                id: dobyyyy
                value: 1970
                minimumValue: 1900
                maximumValue: 9999
                font.pixelSize: 20 * fudge
            }
        }

        CheckBoxItem
        {
            id: dobshow
            width: parent.width
            //height: 42 * fudge

            text: "Any Date of Birth"
            image: false
        }

        Text
        {
            text: "Minimum Height"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter

            SpinBox
            {
                id: heightfoot
                value: 1
                minimumValue: 1
                maximumValue: 10
                font.pixelSize: 20 * fudge
            }
            Text
            {
                text: "'"
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
            }
            SpinBox
            {
                id: heightinch
                value: 1
                minimumValue: 1
                maximumValue: 12
                font.pixelSize: 20 * fudge
            }
            Text
            {
                text: "\""
                color: "black"
                font.pixelSize: 20 * fudge
                renderType: Text.NativeRendering
            }
        }

        CheckBoxItem
        {
            id: heightshow
            width: parent.width
            //height: 42 * fudge

            text: "Any Height"
            image: false
        }

        Text
        {
            text: "Body Type"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ComboBox
        {
            anchors.horizontalCenter: parent.horizontalCenter

            id: bodytype
            model: [ "Athletic", "Envelopped", "Average" ]
        }

        CheckBoxItem
        {
            id: bodytypeshow
            width: parent.width
            //height: 42 * fudge

            text: "Any Body Type"
            image: false
        }

        Text
        {
            text: "Minimum Income"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        SpinBox
        {
            anchors.horizontalCenter: parent.horizontalCenter

            id: income
            value: 50000
            stepSize: 1000
            minimumValue: 1
            maximumValue: 10000000
            font.pixelSize: 20 * fudge
        }

        CheckBoxItem
        {
            id: incomeshow
            width: parent.width
            //height: 42 * fudge

            text: "Any Income"
            image: false
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

    Component
    {
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

    Component.onDestruction:
    {
        refresh();
    }
}
