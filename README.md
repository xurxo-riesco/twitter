# Project 3 - *Twitter-X*

**Twitter-X** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **16** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User sees app icon in home screen and styled launch screen
- [x] User can sign in using OAuth login flow
- [x] User can Logout
- [x] User can view last 20 tweets from their home timeline
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] User can pull to refresh.
- [x] User can tap the retweet and favorite buttons in a tweet cell to retweet and/or favorite a tweet.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] Using AutoLayout, the Tweet cell should adjust it's layout for iPhone 7, Plus and SE device sizes as well as accommodate device rotation.

The following **optional** features are implemented:

- [x] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can view their profile in a *profile tab*
  - Contains the user header view: picture and tagline
  - Contains a section with the users basic stats: # tweets, # following, # followers
  - [x] Profile view should include that user's timeline
- [x] User should display the relative timestamp for each tweet "8m", "7h"
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. Refer to [[this guide|unretweeting]] for help on implementing unretweeting.
- [x] Links in tweets are clickable.
- [x] User can tap the profile image in any tweet to see another user's profile
  - Contains the user header view: picture and tagline
  - Contains a section with the users basic stats: # tweets, # following, # followers
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [x] When composing, you should have a countdown for the number of characters remaining for the tweet (out of 280) (**1 point**)
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet (**2 points**)
- [x] User sees embedded images in tweet if available
- [x] User can switch between timeline, mentions, or profile view through a tab bar (**3 points**)
- [x] Profile Page: pulling down the profile page should blur and resize the header image. (**4 points**)


The following **additional** features are implemented:

- [x] Any profile view contains the account's timeline
- [x] Clicking on mentions redirects to profile
- [x] Clicking on hashtags redirects to hashtag timeline
- [x] Most viewed user stats
- [x] Search Tab
- [x] Twitter style slide out menu

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Enhance visual design, maybe add some animation pods?
2. Possibility of embedding videos

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/ou9QVoCP72.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://g.recordit.co/q8wNRfU5Lo.gif' title='Auto Layout' width='' alt='AutoLayout' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Couple of challenges with outdated pods and rootviewcontrollers in the AppDelegate.m, nothing major.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- BDBOAuth1Manager
- ResponsiveLabel
- MMDrawerController
- DateTools
- JGProgressHUD


## License

    Copyright [2020] [Xurxo Riesco]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
