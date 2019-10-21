/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Flickable
{
    id: root
    width: parent.width
    height: parent.height
    //horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    contentWidth: parent.width
    contentHeight: nametitle.height + name.height + gendertitle.height + genderMale.height + genderFemale.height + dob.height + dobshow.height + heighttitle.height + height.height + heightshow.height + bodytypetitle.height + bodytype.height + bodytypeshow.height + incometitle.height + income.height + incomeshow.height + 8 * fudge * 19
    clip: true

    property alias name: name

    property alias genderMale: genderMale
    property alias genderFemale: genderFemale

    property alias dobmm: dob.mm
    property alias dobdd: dob.dd
    property alias dobyyyy: dob.yyyy
    property alias dobshow: dobshow

    property alias income: income
    property alias incomeshow: incomeshow

    property alias heightfoot: heightfoot
    property alias heightinch: heightinch
    property alias heightshow: heightshow

    property alias bodytype: bodytype
    property alias bodytypeshow: bodytypeshow

    MouseArea
    {
        anchors.fill: parent
        onClicked: Qt.inputMethod.hide();
    }

    Column
    {
        anchors.fill: parent;
        spacing: 8 * fudge

        Text
        {
            id: nametitle
            text: "Name"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextField
        {
            id: name
            placeholderText: "Username"
            anchors.horizontalCenter: parent.horizontalCenter
            validator: RegExpValidator { regExp: /[a-zA-Z0-9_-]+/}
            style: TextFieldStyle
            {
                textColor: "black"
                background: Rectangle
                {
                    radius: 5
                    color: "white"
                    implicitWidth: 100 * fudge
                    implicitHeight: 30 * fudge
                    border.width: 1
                    border.color: "darkgrey"
                }
            }

            enabled: false
        }

        Text
        {
            id: gendertitle
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

            enabled: false
        }
        RadioButton
        {
            id: genderFemale
            text: "Female"
            exclusiveGroup: genderGroup
            style: radioButtonStyle
            anchors.horizontalCenter: parent.horizontalCenter

            enabled: false
        }

        Date
        {
            id: dob
            anchors.horizontalCenter: parent.horizontalCenter

            text: "Date of Birth"
            enabled: false
        }

        CheckBoxItem
        {
            id: dobshow
            width: parent.width
            //height: 42 * fudge

            text: "Show Date of Birth"
            image: false
        }

        Text
        {
            id: heighttitle
            text: "Height"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row
        {
            id: height
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

            text: "Show Height"
            image: false
        }

        Text
        {
            id: bodytypetitle
            text: "Body Type"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ComboBox
        {
            id: bodytype
            anchors.horizontalCenter: parent.horizontalCenter

            model: [ "Athletic", "Envelopped", "Average" ]
        }

        CheckBoxItem
        {
            id: bodytypeshow
            width: parent.width
            //height: 42 * fudge

            text: "Show Body Type"
            image: false
        }

        Text
        {
            id: incometitle
            text: "Income"
            color: "black"
            font.pixelSize: 20 * fudge
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter
        }

        SpinBox
        {
            id: income
            anchors.horizontalCenter: parent.horizontalCenter

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

            text: "Show Income"
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
}
