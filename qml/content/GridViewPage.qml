/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0

import VPlayPlugins 1.0

IOSPage
{
    width: parent.width
    height: parent.height

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

        Rectangle
        {
            id: gridRectangle
            width: parent.width
            height: parent.height - 42 * fudge

            color: "transparent"

            ListModel
            {
                id: appModel

                ListElement { name: "Profile"; icon: "pics/AddressBook_48.png"; trigger: "qrc:/qml/content/ProfilePage.qml"; badge: "0"  }
                ListElement { name: "Messages"; icon: "pics/AddressBook_48.png"; trigger: "qrc:/qml/content/InboxPage.qml"; badge: "0"  }
                ListElement { name: "Vote"; icon: "pics/AddressBook_48.png"; trigger: "qrc:/qml/content/VotePage.qml"; badge: "0"  }
                ListElement { name: "Bulletinboard"; icon: "pics/AddressBook_48.png"; trigger: "qrc:/qml/content/BulletinboardPage.qml"; badge: "0"  }
                ListElement { name: "Store"; icon: "pics/AddressBook_48.png"; trigger: "qrc:/qml/content/BulletinboardPage.qml"; badge: "0"  }
            }

            GridView
            {
                id: grid
                anchors.fill: parent
                cellWidth: gridRectangle.width / 2
                cellHeight: gridRectangle.width / 2
                focus: true
                clip: true
                model: appModel

                //highlight: Rectangle { color: "lightsteelblue" }

                delegate: Item
                {
                    id: item

                    width: gridRectangle.width / 2 - 4 * fudge
                    height: gridRectangle.width / 2 - 4 * fudge

                    Rectangle
                    {
                        id: rectangle
                        anchors.fill: parent

                        Image
                        {
                            id: myIcon
                            y: 20;
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: icon
                        }

                        Text
                        {
                            anchors { top: myIcon.bottom; horizontalCenter: parent.horizontalCenter }
                            text: name
                            font.pixelSize: 14 * fudge
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                grid.currentIndex = index
                                stackView.push(Qt.resolvedUrl(trigger)).refresh.connect(grid.load);
                            }
                        }

                        border.width: 1
                        border.color: "#888"
                        radius: 8 * fudge

                        Badge
                        {
                            text: badge
                        }
                    }

                    DropShadow
                    {
                        anchors.fill: rectangle
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 8.0
                        samples: 17
                        color: "darkgrey"
                        source: rectangle
                    }
                }

                function load()
                {
                    var http = new XMLHttpRequest();

                    http.open("POST", apiUrl + "getNotifications.php", true);
                    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    http.onreadystatechange = function()
                    {
                        if (http.readyState == 4 && http.status == 200)
                        {
                            var raw = JSON.parse(http.responseText);

                            model.setProperty(1, "badge", raw.newmessage.toString())
                            model.setProperty(2, "badge", (raw.newvote + raw.newmatch).toString())
                        }
                    }
                    http.send(apiData + "&userid=" + facebook.profile.userId);
                }

                Component.onCompleted:
                {
                    load();
                }
            }
        }
    }

    Component.onCompleted:
    {
        var http = new XMLHttpRequest();

        http.open("POST", apiUrl + "insertUserPosition.php", true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.onreadystatechange = function()
        {
            if (http.readyState == 4 && http.status == 200)
            {
                db.transaction
                (
                    function(tx)
                    {
                        tx.executeSql("CREATE TABLE IF NOT EXISTS setting (userid BIGINT NOT NULL PRIMARY KEY, votegender TINYINT NOT NULL DEFAULT 0, voterange FLOAT NOT NULL DEFAULT 500000, postgender TINYINT NOT NULL DEFAULT 3, postrange FLOAT NOT NULL DEFAULT 500000, postlookingfordate TINYINT NOT NULL DEFAULT 1, postlookingforrelationship TINYINT NOT NULL DEFAULT 1, postlookingforencounter TINYINT NOT NULL DEFAULT 1, postlookingforarrangement TINYINT NOT NULL DEFAULT 1, postlookingforpartner TINYINT NOT NULL DEFAULT 1, postlookingforactivity TINYINT NOT NULL DEFAULT 1)");
                        tx.executeSql("INSERT INTO setting (userid, votegender, postgender) VALUES (?, ?, ?)", [facebook.profile.userId, (facebook.profile.gender === "male" ? 1 : 2), 3]);
                    }
                )
            }
        }
        http.send
        (
            apiData
            + "&userid=" + facebook.profile.userId
            + "&latitude=" + coordinate.latitude
            + "&longitude=" + coordinate.longitude
        );

        onesignal.sendTag("userid", facebook.profile.userId);
    }
}
