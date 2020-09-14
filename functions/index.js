const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.onCreateChatUser = functions.firestore
    .document('Users/{userId}/chattingWith/{receiverId}').onCreate((snapshot) => {
        // const userId = snapshot.data().currentUserId;
        // const receiverId = snapshot.data().userId;
        // //const userId = context.params.userId;
        // const userRef = admin.firestore().doc(`Users/${userId}/chattingWith/${receiverId}`);
        // const doc = await userRef.get().then(() => console.log('done'))
        //     .catch(err => console.log(err));

        const currentUserId = snapshot.data().currentUserId;
        const Time = snapshot.data().time;
        const receiverId = snapshot.data().userId;
        console.log(Time);

        setTimeout(myfunc, Time * 60000);


        function myfunc() {
            admin
                .firestore()
                .collection("Users")
                .doc(currentUserId)
                .collection("chattingWith")
                .doc(receiverId)
                .get()
                .then(doc => {
                    if (doc.exists) {
                        doc.ref.delete();
                        console.log("done");
                    }
                }).then(() => {
                    console.log("done2")
                }).catch(error => {
                    console.error(error);
                });
        }

    });






exports.onCreateActivityFeedItem = functions.firestore
    .document('feed/{userId}/feed/{receiverId}')
    .onCreate(async(snapshot, context) => {
        const userId = context.params.userId;
        const userRef = admin.firestore().doc(`Users/${userId}`);
        const doc = await userRef.get();


        const androidNotificationToken = doc.data().androidNotificationToken;
        const createActivityFeedItem = snapshot.data();


        if (androidNotificationToken) {
            sendNotification(androidNotificationToken, createActivityFeedItem);
        } else {
            console.log("No token for user, can not send notification.");
        }

        function sendNotification(androidNotificationToken, receiverId) {
            let body;

            switch (receiverId.doesAccepted) {
                case true:
                    body = `${receiverId.username} accept your chat request.`;
                    break;

                case false:
                    body = `${receiverId.username} Reject your chat request.`;
                    break;

                default:
                    body = `${receiverId.username} Send you a Message.`;
                    break;


            }

            const message = {
                notification: {
                    body,
                },
                android: {
                    notification: {
                        sound: "default",
                    }
                },
                token: androidNotificationToken,
                data: { recipient: userId },
                // sound: "default",

            };

            admin.messaging().send(message)
                .then(response => {
                    console.log("Successfully sent message", response);
                })
                .catch(error => {
                    console.log("Error sending message", error);
                })

        }
    });


exports.onCreateChatRequestItem = functions.firestore
    .document('chatRequest/{userId}/chatRequest/{receiverId}')
    .onCreate(async(snapshot, context) => {
        const userId = context.params.userId;
        const userRef = admin.firestore().doc(`Users/${userId}`);
        const doc = await userRef.get();


        const androidNotificationToken = doc.data().androidNotificationToken;
        const createActivityFeedItem = snapshot.data();


        if (androidNotificationToken) {
            sendNotification(androidNotificationToken, createActivityFeedItem);
        } else {
            console.log("No token for user, can not send notification.");
        }

        function sendNotification(androidNotificationToken, receiverId) {
            let body;

            switch (receiverId.doesAccepted) {
                case false:
                    body = `${receiverId.username} Send You a chat request.`;
                    break;

                default:
                    body = `${receiverId.username} Send you a Message.`;
                    break;


            }

            const message = {
                notification: {
                    body,
                },
                android: {
                    notification: {
                        sound: "default",
                    }
                },
                token: androidNotificationToken,
                data: { recipient: userId },
                // sound: "default",
            };

            admin.messaging().send(message)
                .then(response => {
                    console.log("Successfully sent message", response);
                })
                .catch(error => {
                    console.log("Error sending message", error);
                })

        }
    });


exports.onCreateAcceptRequest = functions.firestore
    .document('messages/{chatId}/{chatIdA}/{time}')
    .onCreate(async(snapshot, context) => {
        const chatId = context.params.chatId;
        const userRef = admin.firestore().doc(`messages/${chatId}`);
        const doc = await userRef.get();

        const androidNotificationToken = doc.data().androidNotificationToken;

        const createActivityFeedItem = snapshot.data();


        if (androidNotificationToken) {
            sendNotification(androidNotificationToken, createActivityFeedItem);
        } else {
            console.log("No token for user, can not send notification.");
        }

        function sendNotification(androidNotificationToken, datas) {
            let body;

            //   let body = `${data.username}:- ${data.content}`;
            switch (datas.type) {
                case 0:
                    body = `${datas.username} send you a message :- ${datas.content}`;
                    break;

                case 1:
                    body = `${datas.username} send you an image.`;
                    break;

                default:
                    body = `${datas.username} Send you a gif.`;
                    break;

            }

            const message = {
                notification: {
                    body,
                },
                android: {
                    notification: {
                        sound: "default",
                    }
                },
                token: androidNotificationToken,
                data: { recipient: snapshot.data().idTo },
                // sound: "default",

            };

            admin.messaging().send(message)
                .then(response => {
                    console.log("Successfully sent message", datas.username, response);
                })
                .catch(error => {
                    console.log("Error sending message", error);
                })

        }
    });