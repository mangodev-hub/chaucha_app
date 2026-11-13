// Service worker de Firebase Cloud Messaging (Web Push).
// Muestra el aviso cuando la pestaña está minimizada o cerrada.
// Estos valores son públicos (los mismos de FIREBASE_WEB_* en env.json):
// el service worker no puede leer --dart-define, por eso van aquí.
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDsXmm-myPFwGub3dPEOQGSq1_jsBa_pqE',
  appId: '1:74930550897:web:4ad00af8c5c4eb4b74c3d0',
  messagingSenderId: '74930550897',
  projectId: 'chauchaapp1',
});

// Con `notification` en el mensaje, el SDK muestra el aviso solo.
firebase.messaging();
