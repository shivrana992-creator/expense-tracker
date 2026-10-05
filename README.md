# KharchaMate

> An optimized application for daily expense tracking and finance management. <br />

![MMAS (820 x 360 px)](https://user-images.githubusercontent.com/72301141/206877824-90492e92-2e2d-4de6-b23c-312f283bdfd6.png)


## Setup

Install Flutter 3.47 and the Android SDK. From the project root:

```sh
flutter pub get
flutter devices
flutter run -d <android-device-id>
```

Start an Android emulator or connect an Android phone before running the last
command. If `flutter doctor` reports missing Android command-line tools, install
them through Android Studio's SDK Manager. The app saves its data locally and
opens directly to the tracker; there is no online account sign-in.

If an Android build reports that an NDK directory has no `source.properties`,
reinstall the reported NDK version from Android Studio's SDK Manager before
retrying the build.

To check the project:

```sh
flutter test
flutter analyze lib test
flutter build apk --debug
```


## App icon

The launcher icon source is `images/budget.png`. After replacing this image,
regenerate the Android and iOS icons with:

```sh
flutter pub get
dart run flutter_launcher_icons
```

Rebuild and install the app to see the updated launcher icon.

## Original MMAS app:

https://apps.apple.com/vn/app/mmas-money-tracker/id1582638369


## Screenshots

<table width="100%">
  <tbody>
    <tr>
      <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206411105-4a64ada8-2a9c-4804-ad59-59302a6a82c5.jpg"/></td>
      <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417378-9da25e84-bf21-401c-bf23-bce3b352311e.jpg"/></td>
       <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417548-787625af-f4b1-4c9d-8aac-fa9bd7c47bfb.jpg"/></td>
    </tr>
    <tr>
      <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417565-01bc0f8c-27a4-4648-a845-0a7c29a957c2.jpg"/></td>
      <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417707-be626efa-6bed-41be-a932-4e7a5aa22039.jpg"/></td>
       <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417743-8a51d828-efe0-4d3e-9f6b-5b16a4f3b086.jpg"/></td>
    </tr>
    <tr>
      <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417756-a979fefe-23f8-4a21-bfa5-7e45745c19f0.jpg"/></td>
      <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417834-25dc5bb4-c099-4d90-81a6-eb4e469bc40e.jpg"/></td>
       <td width="1%"><img src="https://user-images.githubusercontent.com/72301141/206417851-2ee18113-04bf-48ae-bf83-d377b4517742.jpg"/></td>
    </tr>
  </tbody>
</table>


## LICENSE
MMAS: Money Tracker is [MIT-licensed](https://github.com/floranguyen0/mmas-money-tracker/blob/main/LICENSE).
