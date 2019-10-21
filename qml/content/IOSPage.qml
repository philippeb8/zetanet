/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0
//import "../settings.js" as Settings

Item
{
    id: wholePage
    default property alias contents: pageContent.data
    property alias menu: backgroundOverlay.menu
    property string mobileNumber: ""
    property bool _menuIsActive: false

    property alias backgroundColor: pageContent.color

    // if null, the default ones are used
    property var pushTransition: null
    property var popTransition: null

    function showMenu()
    {
        _menuIsActive = true
    }

    function hideMenu()
    {
        _menuIsActive = false
    }

    Rectangle
    {
        id: pageContent
        anchors.fill: parent
        //anchors.topMargin: 10 * fudge //statusBar.height
        color: "#f6f5f1"
    }

    // Ugly hack for status bar area dimming. Doesn't have desaturation and just shows gray rectangle on top
    Item
    {
        id: statusBarOverlay
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        //anchors.topMargin: -5
        visible: backgroundOverlay.visible
        opacity: backgroundOverlay.opacity
        z: 500
        height: 20 * fudge

        /*
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.4
        }
        */
    }

    Item
    {
        id: backgroundOverlay
        anchors.fill: parent
        anchors.top: parent.top
        //anchors.topMargin: 10 * fudge //statusBar.height
        visible: false
        opacity: 0

        Desaturate
        {
            anchors.fill: parent
            source: pageContent
            desaturation: 0.8

            Rectangle
            {
                anchors.fill: parent
                color: "black"
                opacity: 0.4
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        _menuIsActive = false
                    }
                }
            }
        }

        property Item menu: Item {}

        onMenuChanged:
        {
            if (menu)
            {
                menu.parent = backgroundOverlay
                menu.anchors.left = backgroundOverlay.left
                menu.anchors.right = backgroundOverlay.right
                menu.anchors.top = backgroundOverlay.bottom
            }
        }
    }

    states:
    [
        State
        {
            name: "menuIsActive"
            when: _menuIsActive
            PropertyChanges
            {
                target: backgroundOverlay
                opacity: 1
            }
            PropertyChanges
            {
                target: backgroundOverlay
                visible: true
            }
            AnchorChanges
            {
                target: menu
                anchors.top: undefined
                anchors.bottom: backgroundOverlay.bottom
            }
        }
    ]

    // First make things visible (even with opacity 0), then increase opacity
    transitions:
    [
        Transition
        {
            from: "*"
            to: "menuIsActive"
            SequentialAnimation
            {
                PropertyAnimation
                {
                    properties: "visible"
                }
                ParallelAnimation
                {
                    AnchorAnimation
                    {
                        easing.type: Easing.InOutQuad
                        duration: 80
                    }
                    PropertyAnimation
                    {
                        properties: "opacity"
                        duration: 50
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        },
        Transition
        {
            from: "menuIsActive"
            to: "*"
            SequentialAnimation
            {
                ParallelAnimation
                {
                    AnchorAnimation
                    {
                        easing.type: Easing.InOutQuad
                        duration: 80
                    }
                    PropertyAnimation
                    {
                        properties: "opacity"
                        duration: 80
                        easing.type: Easing.InOutQuad
                    }
                }
                PropertyAnimation
                {
                    properties: "visible"
                }
            }
        }
    ]
}
