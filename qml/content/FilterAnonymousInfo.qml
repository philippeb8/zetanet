/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

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

        Text
        {
            text: "Gender"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //ExclusiveGroup { id: genderGroup }
        RadioButton
        {
            id: genderMale
            text: "Male"
            //exclusiveGroup: genderGroup
            style: radioButtonStyle
            anchors.horizontalCenter: parent.horizontalCenter
        }
        RadioButton
        {
            id: genderFemale
            text: "Female"
            //exclusiveGroup: genderGroup
            style: radioButtonStyle
            anchors.horizontalCenter: parent.horizontalCenter
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
            model: [ "All", "Athletic", "Envelopped", "Average" ]
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
