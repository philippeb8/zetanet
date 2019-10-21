/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import QtPositioning 5.2

IOSPage
{
    id: root
    width: parent.width
    height: parent.height

    property Item pictureMenu: PictureMenu {}

    property alias list: list;

    property bool postShown: true;

    signal refresh();

    Column
    {
        anchors.fill: parent

        ToolBarItem
        {
            width: parent.width
            height: 42 * fudge

            titleText: "Fornux ZetaNet 0.1"

            onRefresh: root.refresh();
        }

        MessageItem
        {
            id: search
            width: parent.width
            height: 42 * fudge
            placeholderText: "Search"
        }

        MessageItem
        {
            id: address
            width: parent.width
            height: 42 * fudge
            placeholderText: "Current location, address or place"
        }

        Row
        {
            height: 42 * fudge
            spacing: 8 * fudge

            RangeItem
            {
                id: range
                width: root.width
                showText: false
            }
        }

        Button
        {
            id: post
            width: parent.width
            height: 42 * fudge
            visible: postShown

            style: ButtonStyle
            {
                label: Text
                {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 14 * fudge
                    font.family: "FontAwesome"
                    text: "Post"
                }

                background: Rectangle
                {
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 16 * fudge
                    gradient: Gradient
                    {
                        GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                        GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                    }
                }
            }

            onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/content/PostPage.qml"), {pushTransition: stackView.transitionSlideFromBottom, popTransition: stackView.transitionSlideToBottom}).refresh.connect(mainPage.list.load);

            //onClicked: Qt.openUrlExternally(textString);
        }

        ProfileList
        {
            id: list
            width: parent.width;
            height: parent.height - 42 * fudge * 4
            //imageShown: false;

            Component.onCompleted:
            {
                search.textUpdated.connect(list.load);
                address.textUpdated.connect(list.load);
                range.refresh.connect(list.load);

                //list.load();
            }

            Component.onDestruction:
            {
            }

            onRefresh:
            {
                list.load();
            }

            function load()
            {
                model.clear();

                bottom();
            }

            function loadLimit(low, hi)
            {
                var http = new XMLHttpRequest();

                http.open
                (
                    "GET",
                    apiUrl
                    + "search?"
                    + "&format=json"
                    + "&query=" + encodeURIComponent(search.text)
                    + "&address=" + encodeURIComponent(address.text)
                    + "&lat=" + coordinate.latitude
                    + "&lng=" + coordinate.longitude
                    + "&distance=" + (range.range.value / 1000)
                    + "&offset=" + low,
                    true
                );
                http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                http.onreadystatechange = function()
                {
                    if (http.readyState === XMLHttpRequest.DONE && http.status === 200)
                    {
                        var raw = JSON.parse(http.responseText);

                        for (var i = 0; i < raw.length; ++ i)
                        {
                            var myself = false;
                            model.append({isAd: false, textShown: false, chatShown: false, blockShown: myself, dropShown: !myself, id: "", userId: "", subjectString: raw[i].titlecache + "<br><font color='green'>" + raw[i].positioncache + "<br></font><font color='gray'><i>(until " + raw[i].expiration + ")</i></font>", textString: raw[i].url, albumModel: [], ratioText: ""});

                            var urllist = raw[i].imageurlcache.split(' ');

                            for (var j = 0; j < urllist.length; ++ j)
                                model.get(model.count - 1).albumModel.append({imageId: "", imageUrl: urllist[j], imageBlur: 0});
                        }
                    }
                }
                http.send();
            }

            onBottom:
            {
                list.loadLimit(list.container.count, list.container.count + 10)
            }

            onTextClicked:
            {
                //stackView.push({item: Qt.resolvedUrl("qrc:/qml/content/SubSubRankPage.qml"), properties: {userId: userId}});
            }

            onDropClicked:
            {
                var http = new XMLHttpRequest();

                http.open("POST", apiUrl + "deletePost.php", true);
                http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                http.onreadystatechange = function()
                {
                    if (http.readyState === XMLHttpRequest.DONE && http.status === 200)
                    {
                    }
                }
                http.send(apiData + "&postid=" + id);
            }
        }
    }
}
