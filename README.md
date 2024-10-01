# library-flutter-app
## How to run the app
### 1. Download the things listed below:
1. Node.js https://nodejs.org/en
2. Visual Studio Code https://code.visualstudio.com/
3. Android studio https://developer.android.com/studio
4. Git https://git-scm.com/
5. Flutter https://docs.flutter.dev/ 

> Watch this video on how to download flutter 
> https://youtu.be/DvZuJeTHWaw?list=PL4cUxeGkcC9giLVXCHSQmWqlHc9BLXdVx
### 2. Clone this repository
- Right click on your desktop and click "Open GitBash here"
- Paste in the terminal (shift + ins) "git clone https://github.com/marko-stupin/library-flutter-app.git"
- Press Enter
### 3. Open up Android Studio and download a simulator/device there 
### 4. Go back to the terminal window and paste this and enter
- cd library-flutter-app && code .
### 5. Vs Code will open 
- At the right bottom of the vs code window you will see something like "Windows(windows-x64)" click on that and your device/emulator that you downloaded will be there, click on it and it will start
### 6. Running the app 
> - Make sure you're in the vs code window
> - Go to the .env file in the backend folder and next to "MONGO_URI=" paste the key that I sent you privately then press Ctrl+S
> - It should look like this: MONGO_URI=mongodb+srv://username:password@cluster0.sduefst.mongodb.net/

ctrl + button under escape
cd backend 
npm i
npm run dev 
ctrl + shift + button under escape
cd frontend 
flutter pub get 
flutter run 
### 7. App will now open
