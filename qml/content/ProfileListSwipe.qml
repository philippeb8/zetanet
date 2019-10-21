/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.7
import QtQuick.Controls 1.1

Item
{
    id: root
    property alias container: container;
    property alias model: container.model;

    signal imageClicked(string imageId);
    signal subjectClicked(string userId);
    signal textClicked(string userId);
    signal voteClicked(string imageId, int vote);
    signal dropClicked(string id);
    signal top();
    signal bottom();
    signal refresh();

    property bool imageShown: true;
    property bool textShown: true;
    property bool voteShown: false;
    property bool moreShown: true;
    property bool chatShown: false;
    property bool blockShown: false;
    property bool dropShown: false;
    property bool ratioShown: false;
    property bool albumMaximised: true;

    ListView
    {
        id: container
        objectName: "list"
        anchors.fill: parent
        anchors.margins: 8 * fudge
        clip: true
        model: listModel
        spacing: 8 * fudge

        delegate: ProfileListSwipeDelegate {}

        //spacing: 8 * fudge
        property bool bannerStart: false
        property int savedIndex;

        onCountChanged:
        {
            currentIndex = savedIndex;
        }

        AnimatedImage
        {
            id: loading
            width: 40 * fudge
            height: 40 * fudge
            anchors.centerIn: parent
            source: "loading.gif"
            visible: false
        }

        Timer {
            id: timer
            interval: 500; running: true;
            onTriggered: loading.visible = false
        }

        onContentYChanged:
        {
            if (bannerStart && !loading.visible)
                if (atYBeginning && verticalVelocity <= -300 * fudge)
                {
                    loading.visible = true
                    savedIndex = 0;
                    root.top();
                }
                else if (atYEnd && verticalVelocity >= 300 * fudge)
                {
                    loading.visible = true
                    savedIndex = count - 1
                    root.bottom();
                }
        }
        onMovementStarted:
        {
            if (atYBeginning || atYEnd)
                bannerStart = true;
            else
                bannerStart = false;
        }
        onVerticalVelocityChanged:
        {
            // Prevent triggering pulldown item when rebound from top boundary.
            if (atYBeginning && verticalVelocity>0 || atYEnd && verticalVelocity<0)
                bannerStart = false;
        }
        onMovementEnded:
        {
            bannerStart = false;
            // trigger timer to hide pull-down item
            timer.restart();
        }

        add: Transition
        {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
        }

        displaced: Transition
        {
            NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
        }
    }

    ListModel
    {
        id: listModel
    }
}
