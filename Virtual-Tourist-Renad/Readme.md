
# OverView: 
This app allows the user to  specify a spesfic location and displays a photo album useing Flickr API for each location. The locations and photo albums will be stored in Core Data.
This app has  two view controller scenes , Map View which Allows the user to drop pins around the world. Collection View which Allows the users to download , share and delete an album for a location, also you can have new collection of photos by clicking on the 'new collection' button. This app uses CoreDate, SystemConfiguration, MapKit and do network request to Flickr API. 


# Requirements:

1. Long press on any point on the map to place a pin.
![Screenshot](Screenshots/image0.PNG)

2. Press the pin then press the poped up latitude/longitude view in order to access photo album of that pin.
![Screenshot](Screenshots/image1.PNG)

3. The app will then download a set of photos from Flickr associated with the coordinations of the pin and present it to the user.
![Screenshot](Screenshots/image3.PNG)

4.  Pressing "New Collection" button at the up-right corner will download new set of photos.
![Screenshot](Screenshots/image4.PNG)

5. while fetching the photo from the server  a text will show up as the following 
![Screenshot](Screenshots/image2.PNG)

6. in case if any network proplem an alert will pop up with a text " please connect to the internet and try agian"
![Screenshot](Screenshots/image5.PNG)


7.  Single touch on any photo to delete it.
8. Long touch on any photo to save or share the photo.




# Prerequisites:
It was built using Xcode Version 10.1 (10B61)   and iOS 10.14.1 along with Swift 4.

# Installatation:
1. Download project zip or git clone the project https://github.com/renadmen/Virtual-Tourist.git
2. Navigate to the project folder in Terminal.
3. Open Virtual Tourist.xcodeproj.
4. Build and Run in iOS Simulator or on your device.



