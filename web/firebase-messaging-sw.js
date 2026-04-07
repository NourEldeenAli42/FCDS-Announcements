importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCB-Cd4Dubr45LdHHUXcv6YJaqguzcPzmM",
  appId: "1:921251262968:web:3b75eea685fb65e26ce60d",
  messagingSenderId: "921251262968",
  projectId: "fcds-announcements-7dbbd",
  authDomain: "fcds-announcements-7dbbd.firebaseapp.com",
  storageBucket: "fcds-announcements-7dbbd.firebasestorage.app",
  measurementId: "G-DQG9336S8K"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("Received background message: ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
