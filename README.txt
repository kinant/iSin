# READEME: iSIN - Sin tracker for iOS

About: iSin is an app that allows you to keep track of the sins that you have committed. This is
to help you when it comes to making a confession or recognizing were you could do better in 
your religious life. 

# Installation Instructions:

1. Build and Run
2. To use TouchID authentication, a capable device is necessary. The app will work without authentication for the iOS Simulator. 
3. If you wish to disable the authentication screen for non-TouchID compliant devices, please remove the following lines inside
the applicationDidBecomeActive function in AppDelegate.swift:

let authVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("AuthenticateVC") as! AuthenticateViewController
self.window?.rootViewController?.presentViewController(authVC, animated: false, completion: nil)

## How to use:

# Running for the first time:
1. If authentication is enabled, the app will ask you to create a password for authentication. 
2. Once password is set, the app will ask user to authenticate with TouchID or with password. 
3. Press the iTouch button on the screen at anytime to authenticate. 

# Main Menu:
1. Click the menu button at the top left corner of the screen. 
2. The menu allows you to: 1) View the sins (main window), 2) view your sin records (saved sins) and 3) view the settings screen. 

To view the sins:
1. Swipe across the screen or use the top tab-bar to view all the different sin types. 
2. Click on the + button at the bottom of the screen to proceed to add a sin. 

# Adding a Sin:
1. In the first screen, select the sin that you want to add. API sins are downloaded from the iSin API. 
2. If you would like to use a custom Sin, please press the add custom sin button at the bottom. 
3. Once a sin is selected, the app will proceed to the Add Passages screen.
4. You can swipe a sin in the table at any point to delete it. Just swipe and select "Delete". 
5. You can press the refresh button to re-download data from API

# Adding a Passage:
1. Once a sin is selected, the add passages screen allows you to add passages (relevant to the sin) to your sin record. 
2. The app lists passages that were downloaded using iSin API and text from bible.org API (labs.bible.org). 
3. The table will show the title for the passages (book, chapter and verses). To view the text of a chapter, click on the read
icon to the right. 
4. If you wish to add your own custom passage, please press the "Add Custom Passage" button. In the prompt, input the book, chapter and verses
that you wish to add. The app will then search for the passage in bible.org API. If found, it will ask you to confirm the passage. Once you confirm,
it will show up in the list under "Custom Passages".
5. You can swipe a passage in the table at any point to delete it. Just swipe and select "Delete". 
5. You can press the refresh button to re-download data from API

# Viewing Sin Records:
1. To view sin records, press the menu button and choose "MY SIN RECORDS".
2. The sin records window will appear, listing all the sin records that have been saved.
3. Click on any row to view details for the record. 
4. The details screen displays the sin record information, along with the sin commited, it's type and the list
of any passages saved. Click on any passage to view it's text. 
5. On the "My Sin Records" screen, you can swipe a sin record row at any time to delete. 

# Settings:
1. The settings screen allows you to set the authentication method. If you want the app to ask to authenticate everytime that it
becomes active, please turn the option ON, otherwise, leave it off (App will only authenticate once, when it starts).