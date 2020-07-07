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
* Ability to pull "My Places" data from the Google Maps API/SDK and create lists based on that.
* Ability to specify how many days you want to spend in that specific area and how long you want to visit attractions for every day.
* Ability to calculate the most efficient order of visiting these locations and specifying on what day the user should visit each
* Implementation of the Google maps SDK to see the daily directions.
* Ability to view a list.
* Ability to login to the App using one's Google account.

**Optional Nice-to-have Stories**

* Ability to view other people's lists (friends, but how do I implement the friends feature?)
* Ability to save other people's lists
* The app can suggest popular places to visit that are in the area you are visiting
* The app can recognize which places are food related and place them at times of the day when one usually eats/limits the number of food places to a specified amount.
* The app suggests how long to spend at each location
* The app takes into account when the locations are closed and does not suggest them then.
* Ability to view a details page for each location
* Ability to edit a list


### 2. Screen Archetypes

* Login Page
   * Ability to login to the App using one's Google account.
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
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
