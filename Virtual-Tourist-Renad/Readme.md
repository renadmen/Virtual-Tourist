
# OverView: 
This app allows the user to  specify a spesfic location and displays a photo album useing Flickr API for each location. The locations and photo albums will be stored in Core Data.
This app has  two view controller scenes , Map View which Allows the user to drop pins around the world. Collection View which Allows the users to download , share and delete an album for a location, also you can have new collection of photos by clicking on the 'new collection' button. This app uses CoreDate, SystemConfiguration, MapKit and do network request to Flickr API. 


# Requirements:

1. Long press on any point on the map to place a pin.
2. Press the pin then press the poped up latitude/longitude view in order to access photo album of that pin.
3. The app will then download a set of photos from Flickr associated with the coordinations of the pin and present it to the user.
4.  Pressing "New Collection" button at the up-right corner will download new set of photos.
5.  Single touch on any photo to delete it.
6. Long touch on any photo to save or share the photo.

![image](/Screenshots/image0.PNG)
![Screenshot](Screenshots/image1.PNG)
![Screenshot](Screenshots/image2.PNG)
![Screenshot](Screenshots/image3.PNG?raw=true)
![Screenshot](Screenshots/image4.PNG?raw=true)
![Screenshot](Screenshots/image5.PNG?raw=true)




# Prerequisites:
It was built using Xcode Version 10.1 (10B61)   and iOS 10.14.1 along with Swift 4.

# Installatation:
1. Download project zip or git clone the project https://github.com/renadmen/Virtual-Tourist.git
2. Navigate to the project folder in Terminal.
3. Open Virtual Tourist.xcodeproj.
4. Build and Run in iOS Simulator or on your device.



