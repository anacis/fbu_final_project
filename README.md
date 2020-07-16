# Travelr

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This app will allow a user to create a list of locations in a city/small area that they would like to visit in N days and then will suggest the most efficient method of visiting all those locations given the time constraints. The app will use the Google Maps SDK. If time permits, I will add the ability to share the lists of locations with the user's friends.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Travel
- **Mobile:** People generally rely on cells phones for travel as they are light-weight and portable, therefore this app is perfect for a mobile setting.
- **Story:** This app tracks the user's desired locations to visit and whether or not the user actually reached their destination. Over the years, the user can reflect on all of the wonderful places they were able to travel to and can provide recommendations to their friends.
- **Market:** Anyone who travels and does not use a travel agent, ie: most people
- **Habit:** The app is not addictive in the sense that a user would open it every day of every year, yet I believe that users would often quite often whenever they are traveling or creating travel plans. The user both consumes (the suggested order of places to visit) and creates(the lists of places to visit) on the app.
- **Scope:** The scope of this app could be expanded to include social features such as sharing lists of locations with friends or sharing recommendations/ratings of specific locations.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Ability to create lists of places on google maps (Restaurants, museums, vistas, architectural attractions, etc..) (maybe divide in multiple model: food, attractions, etc)
* The user can view all of their lists in a feed
* Ability to specify how many days you want to spend in that specific area and how long you want to visit attractions for every day.
* Ability to calculate the most efficient order of visiting these locations and specifying on what day the user should visit each
* Implementation of the Google maps SDK to see the daily directions.
* Ability to view a list.
* Ability to login to the App using one's Google/Facebook account.

**Optional Nice-to-have Stories**
* Ability to pull "My Places" data from the Google Maps API/SDK and create lists based on that.
* Ability to view other people's lists (friends, but how do I implement the friends feature?)
* The app can suggest popular places to visit that are in the area you are visiting
( * The app can recognize which places are food related and place them at times of the day when one usually eats/limits the number of food places to a specified amount. ) 
* The app suggests how long to spend at each location
* The app takes into account when the locations are closed and does not suggest them then.
* Ability to view a details page for each location
* Ability to edit a list


### 2. Screen Archetypes

* Login Page
   * Ability to login to the App using one's Google/Facebook account.
* List Feed Page
   * The user can view all of their lists in a feed
   * Ability to pull "My Places" data from the Google Maps API/SDK and create lists based on that.
* Location Feed Plage
    * Ability to view a list
* Maps Page
    * Implementation of the Google maps SDK to see the daily directions.
* List Creation Page
    * Ability to create lists of places on google maps (Restaurants, museums, vistas, architectural attractions, etc..) (maybe divide in multiple model: food, attractions, etc)
    * Ability to specify how many days you want to spend in that specific area and how long you want to visit attractions for every day.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Feed
* Profile (but later)

**Flow Navigation** (Screen to Screen)

* Login Page
   * => List Feed Page
* List Feed Page
   * => Location Feed Page 
   * => List Creation Page
* Location Feed Page
    * => Maps Page

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/anacis/travelr/blob/master/images/IMG_0376.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
#### PlaceList

   | Property      | Type     | Description | In Database |
   | ------------- | -------- | ------------| ------------|
   | name          | String   | list name | Yes |
   | author        | Pointer to User| list author | Yes |
   | image        | File     | An identifying image that the user can set | Yes |
   | description   | String   | The list’s description | Yes |
   | numDays       | Number   | The number of days the user will be in the list’s general area | Yes |
   | numHours      | Number   | The number of hours the user wishes to spend on tourism | Yes |
   | placesUnsorted| Array | The places the user wishes to travel in the order the user inputs them | Yes |
  
Note: I will only store the unsorted list of places and run the sorting algorithm every time the list is loaded.
Question: What is the best way to store the associated number of hours the user wishes to spend at each location?
 
#### Place (or do I get this from the Maps SDK?)
| Property      | Type     | Description |
   | ------------- | -------- | ------------| 
   | name          | String   | place name |
   | image        | File     | an identifying photo from the API/SDK |
   | description   | String   | The list’s description |
   | latitude     | Number   | latitude for Maps feature | 
   | longitude      | Number   | longitude for Maps feature |
   | locationType| String | the type of location (restaurant, museum, beach, etc) used for timeSpent calculation| 
   | openingHours | String | the hours when the place is open |
   | apiID        | String  | The ID of the location from the API |

Note:
* Google Maps has a type Object: GMSPlaceField which could represent a place.
https://developers.google.com/places/ios-sdk/place-data-fields
* Need to figure out how to pass place into map call URL
* Google Maps 
  * doesn’t have an API call to get the typical time a person spends at a certain place (might need to set a standard time spent depending on the type of place it is)
  * it does however have the opening hours.
* Apple Maps doesn’t have a place API so I would need to use the foursquare API (I previously used this in the PhotoMap lab) or find another API.

#### User
| Property      | Type     | Description |
   | ------------- | -------- | ------------| 
   | username          | String   | username set by user|
   | profilePhoto         | File     | an identifying photo set by the user |
   | password   | String   | password set by user|

General Note: Using the google Maps Places API is not free :( the Maps SDK is free and seems to provide similar functionality, but might need to result to using the fourSquare API instead. I could also pay for the API since it's not that expensive. -- update: I can use my free google cloud credits for API calls yay!

### Networking
* Sign Up Screen
  * (Create/POST) Create a new user object
* List Feed Screen
  * (Read/GET) Query all lists where user is author
* List Creation Screen
  * (Update/PUT) Update list photo by pressing on the photo
  * Create/POST) Create a new list
* Location Feed Screen
  * (Read/GET) Query all Places in the list
  * (Read/GET) Query all Days in the list(?)

- [OPTIONAL: List endpoints if using existing API such as Yelp]
