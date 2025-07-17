# 📓 VOYATEKTRIP - iOS App

Trip Planner is an iOS app built with UIKit that allows users to create, view, and manage travel plans. The app supports uploading trips with destinations, dates, descriptions, and travel styles, and provides a clean UI with mock and API data support.

---

## ✨ Features

* 🗕️ Create a new trip with start/end dates using a date picker.
* 🌍 Add destination, trip title, travel style, and description.
* 📤 Submit trip details to backend via POST request.
* 📥 Fetch all trips via GET and display them in a collection view.
* 🖼️ Trips include destination, number of days, and dates.
* 🎨 Custom-designed reusable UI components (cells, popups).
* 📀 Auto Layout with dynamic vertical stack views.

---

## 🏗️ Technologies Used

* **Language:** Swift
* **UI Framework:** UIKit
* **Networking:** `URLSession`
* **Design:** Storyboard, Auto Layout,
* **Architecture:** MVVM
* **Backend:** Custom API with mock data
* **Version Control:** Git, GitHub

---


## 💠 How to Run

1. Clone the repo:


2. Open in Xcode:


3. Build and run on iOS Simulator or device.

---

## 🔗 API Endpoints

### Create Trip (POST)

* `POST /api/trips`
* Request body:

```json
{
  "tripName": "Trip to Lagos",
  "travelStyle": "Solo",
  "startDate": "2025-07-20",
  "endDate": "2025-07-25",
  "description": "Fun trip to Lagos",
  "destination": "Lagos"
}
```

* Response:

```json
{
  "status": true,
  "message": "okay",
  "data": {
    "tripName": "Trip to Lagos",
    "travelStyle": "Solo"
  }
}
```

### Get All Trips (GET)

* `GET /api/trips`
* Returns:

```json
[
  {
    "id": "13C093E6-EC2C-4EA6-9AA3-A0F2AD6BA31F",
    "tripName": "Test",
    "travelStyle": "Couple",
    "startDate": "2025-07-17",
    "endDate": "2025-07-31",
    "description": "Now",
    "destination": "Lagos"
  },
  ...
]
```

---
