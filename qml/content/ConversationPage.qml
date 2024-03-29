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

    signal refresh();

    // app navigation
    Navigation {
      NavigationItem {
        title: "User Profile"
        icon: IconType.user
        NavigationStack {
          initialPage: socialView.profilePage
        }
      }

      NavigationItem {
        title: "Leaderboard"
        icon: IconType.flagcheckered
        NavigationStack {
          initialPage: socialView.leaderboardPage
        }
      }

      NavigationItem {
        title: "Chat"
        icon: IconType.comment
        NavigationStack {
          initialPage: socialView.inboxPage
        }
      }

      NavigationItem {
        title: "Search"
        icon: IconType.search
        NavigationStack {
          initialPage: mySearchPage
        }
      }
    }

    // service configuration
    VPlayGameNetwork {
      id: gameNetwork
      gameId: 285
      secret: "AmazinglySecureGameSecret"
      multiplayerItem: multiplayer

      // increase leaderboard score by 1 for each app start
      Component.onCompleted: gameNetwork.reportScore(1)
    }

    VPlayMultiplayer {
      id: multiplayer
      appKey: "dd7f1761-038c-4722-9f94-812d798cecfb"
      pushKey: "a4780578-5aad-4590-acbe-057c232913b5"
      gameNetworkItem: gameNetwork
    }

    // social view setup
    SocialView {
      id: socialView
      gameNetworkItem: gameNetwork
      multiplayerItem: multiplayer
      visible: false // we show the view pages on our custom app navigation

      // add button to user profile, which opens a custom user detail page
      profileUserDelegate: SocialUserDelegate {
        id: userDelegate
        SocialViewButton {
          anchors.horizontalCenter: !!parent ? parent.horizontalCenter : null
          text: "Show User Details"
          onClicked: {
            // show custom social page and pass gameNetworkUser
            parentPage.navigationStack.push(userDetailPage, { gameNetworkUser: userDelegate.gameNetworkUser  })
          }
        }
      }
    }

    // page for entering and showing user details
    Component {
      id: userDetailPage
      SocialPage {
        title: "User Details"
        // add a property for the user we want to show on the page
        property GameNetworkUser gameNetworkUser: null

        // parse the JSON data stored in customData property, if it is set
        property var userCustomData: !!gameNetworkUser && !!gameNetworkUser.customData ? JSON.parse(gameNetworkUser.customData) : {}

        // for logged-in user, allow editing the custom fields
        Column {
          id: userDetailCol
          x: dp(Theme.navigationBar.defaultBarItemPadding) // add indent
          y: x // padding top
          width: parent.width - 2 * x
          spacing: x
          visible: gameNetworkUser.userId === gameNetworkItem.user.userId // only show if profile of logged-in user

          AppText {
            text: "Edit the fields below to set your details."
          }

          // custom data fields
          Column {
            spacing: parent.spacing

            Row {
              spacing: parent.spacing
              Icon {
                id: inputIcon
                icon: IconType.music; color: Theme.tintColor
                anchors.verticalCenter: parent.verticalCenter
              }
              AppTextField {
                id: songInput
                text: !!userCustomData.song ? userCustomData.song : ""
                width: userDetailCol.width - parent.spacing - inputIcon.width
                placeholderText: "Enter your favorite music genre."
                borderWidth: px(1)
              }
            }

            Row {
              spacing: parent.spacing
              Icon {
                icon: IconType.cutlery; color: Theme.tintColor
                anchors.verticalCenter: parent.verticalCenter
              }
              AppTextField {
                id: foodInput
                text: !!userCustomData.food ? userCustomData.food : ""
                width: userDetailCol.width - parent.spacing - inputIcon.width
                placeholderText: "Enter your favorite food."
                borderWidth: px(1)
              }
            }
          }

          // save button
          SocialViewButton {
            text: "Save"
            onClicked: {
              var customData = JSON.stringify({ "song": songInput.text, "food": foodInput.text })
              gameNetworkItem.updateUserCustomData(customData)
            }
          }
        }

        // for other users, show data of custom fields
        Column {
          x: dp(Theme.navigationBar.defaultBarItemPadding) // add indent
          y: x // padding top
          width: parent.width - 2 * x
          spacing: x
          visible: gameNetworkUser.userId !== gameNetworkItem.user.userId // only show if profile of other user

          // show custom data
          Grid {
            spacing: parent.spacing
            columns: 2
            Icon { icon: IconType.music; color: Theme.tintColor }
            AppText { text: !!userCustomData.song ? userCustomData.song : "" }
            Icon { icon: IconType.cutlery; color: Theme.tintColor }
            AppText { text: !!userCustomData.food ? userCustomData.food : "" }
          }
        }
      }
    }

    // page for searching users based on entered details
    Component {
      id: mySearchPage
      SocialUserSearchPage {
        filterToUsersWithCustomData: true // only show results for users with custom data
        userSearchUserDelegate: SocialUserDelegate {
          height: userSearchCol.height + 2 * userSearchCol.spacing

          // parse the JSON data stored in customData property, if it is set
          property var userCustomData: !!gameNetworkUser && !!gameNetworkUser.customData ? JSON.parse(gameNetworkUser.customData) : {}

          // background of user item
          Rectangle {
            anchors.fill: parent
            color: "white"
            border.width: px(1)
            border.color: socialViewItem.separatorColor
          }

          // show user details
          Column {
            id: userSearchCol
            x: dp(Theme.navigationBar.defaultBarItemPadding) // add indent
            y: x // padding top
            width: parent.width - 2 * x
            spacing: x
            anchors.verticalCenter: parent.verticalCenter

            // profile image + user name
            Row {
              spacing: parent.spacing
              SocialUserImage {
                height: dp(26)
                width: height
                source: gameNetworkUser.profileImageUrl
              }
              AppText {
                text: gameNetworkUser.name;
                anchors.verticalCenter: parent.verticalCenter
              }
            }

            // show custom data
            Grid {
              spacing: parent.spacing
              columns: 2
              Icon { icon: IconType.music; color: Theme.tintColor }
              AppText { text: !!userCustomData.song ? userCustomData.song : "" }
              Icon { icon: IconType.cutlery; color: Theme.tintColor }
              AppText { text: !!userCustomData.food ? userCustomData.food : "" }
            }
          }

          // open profile when selected
          MouseArea {
            anchors.fill: parent
            onClicked: socialViewItem.pushProfilePage(gameNetworkUser, parentPage.navigationStack)
          }
        }
      }
    }
}
