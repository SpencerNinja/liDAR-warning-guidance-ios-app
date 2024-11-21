//
//  Notes.swift
//  Sonic BAT
//
//  Created by Spencer Hurd on 11/15/24.
//

/**
 
 TODO:
    
 - ✅ implement LiDAR scanning
 - ✅ implement sound when object too close
 - ✅ implement vibrate when object too close
 - ✅ design main screen
 - ✅ make start button cover lower half of screen
 - ✅ make stop button
 - ✅ switch between start and stop button
 - ✅ make a settings button for top half of screen
 - ✅ settings:
     - ✅ turn haptics on/off
     - ✅ turn audio beeps on/off
     - ✅ turn audible instructions off
 
- ✅ add start message:
    - ✅ visual
    - ✅ audible
 
 - ✅ appIcon
 - ✅ logo

 - ✅ design landing screen
 - ✅ bats, smokescreen layer effect
 - ✅make sure there is only 1 speech triggering on each page
 
 BACKLOG
 - Does LiDAR work on windows and reflective floors like tile?
 - trigger "warning length" setup wizard on so that the user sets their default "warning length"
 - settings should include a setup wizard for warning distance
 - trigger small beeps for any change in distance greater than 0.3 feet
 - use different types of beeps to tell user if distance increases or decreased (this should catch scenarios where there is a drop in distance as well)
 - improve haptic feedback time
 - implement user-agreement screen
    - email or save acceptances in a database (or we may not need to save the info)
    - redirect deniers to catch screen (logo, copyright, button to user-agreement)
 - link app to Apple Watch
 - add haptics to Apple Watch
 - implement free version and paid version
    - free version: sonar and setup wizard only
    - paid version: settings for beeps, haptics, warning distance increments
 - come up with a better name and logo
 - app screen screenshots and description
 
 
 
 User path
 1. first-time opening the app
    a. Launch Screen
    b. User-agreement and disclaimer: Accept or Deny (A "Deny" send them to a Launch Screen where there is only the logo, copyright, and button to the User Agreement)
    c. Warning Distance setup wizard
 2. Everytime:
    a. Animated Logo screen
    b. The user can listen to the whole Safety Acknowledgement or skip by tapping anywhere
    c. Main menu
 
 
 */
