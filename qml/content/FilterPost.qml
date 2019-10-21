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
    id: root
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

        DoneToolBarItem
        {
            width: parent.width
            height: 42 * fudge

            onRefresh:
            {
                db.transaction
                (
                    function(tx)
                    {
                        tx.executeSql("UPDATE setting SET postlookingfordate=?, postlookingforrelationship=?, postlookingforencounter=?, postlookingforarrangement=?, postlookingforpartner=?, postlookingforactivity=? WHERE userid=?", [lookingfor.lookfordate.checked, lookingfor.lookforrelationship.checked, lookingfor.lookforencounter.checked, lookingfor.lookforarrangement.checked, lookingfor.lookforpartner.checked, lookingfor.lookforactivity.checked, facebook.profile.userId]);

                        root.refresh();
                    }
                )
            }
        }

        Flickable
        {
            width: parent.width
            height: parent.height;
            //horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            contentWidth: parent.width
            contentHeight: parent.height;
            clip: true

            Column
            {
                width: root.width

                ProfileLookingForItem
                {
                    id: lookingfor
                    height: 340 * fudge
                }
            }
        }
    }

    Component.onCompleted:
    {
        db.transaction
        (
            function(tx)
            {
                var rs = tx.executeSql("SELECT postlookingfordate, postlookingforrelationship, postlookingforencounter, postlookingforarrangement, postlookingforpartner, postlookingforactivity FROM setting WHERE userid=?", [facebook.profile.userId]);

                if (rs.rows.length)
                {
                    lookingfor.lookfordate.checked = rs.rows.item(0).postlookingfordate;
                    lookingfor.lookforrelationship.checked = rs.rows.item(0).postlookingforrelationship;
                    lookingfor.lookforencounter.checked = rs.rows.item(0).postlookingforencounter;
                    lookingfor.lookforarrangement.checked = rs.rows.item(0).postlookingforarrangement;
                    lookingfor.lookforpartner.checked = rs.rows.item(0).postlookingforpartner;
                    lookingfor.lookforactivity.checked = rs.rows.item(0).postlookingforactivity;
                }
            }
        )
    }
}
