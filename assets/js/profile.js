// Initialize the firebase
const firebaseConfig = {
    apiKey: "AIzaSyAJT0DnQ_2Ad5G7x3B8X5AFvSkwFYywj0M",
    authDomain: "soulswipe-afd60.firebaseapp.com",
    projectId: "soulswipe-afd60",
    storageBucket: "soulswipe-afd60.appspot.com",
    messagingSenderId: "744182248019",
    appId: "1:744182248019:web:862d81666ffb1ad5720ca6"
};

firebase.initializeApp(firebaseConfig);
let db = firebase.firestore();


// Get the user's email from the query parameter
const urlParams = new URLSearchParams(window.location.search);
const userEmail = urlParams.get("email");

// Getting user data from firestore
db.collection("Users").where("email", "==", userEmail)
.get()
.then((querySnapshot) => {
    if (!querySnapshot.empty) {
        querySnapshot.forEach((doc) => {
        // Access the user's data
        var userData = doc.data();
        document.getElementById("firstName").value = userData.firstName;
        document.getElementById("lastName").value = userData.lastName;
        document.getElementById("job").value = userData.job;
        document.getElementById("email").value = userEmail;
        });
    } else {
        console.log("No user found with the specified email.");
    }
    }).catch((error) => {
        console.error("Error retrieving user data:", error);
    }
);



// Add an event listener to the button
document.getElementById("notifyBtn").addEventListener("click", sendNotification);

function sendNotification() {
    // Notifying the user with a message
    const message = document.getElementById("notify-user").value;

    if(message == "") {
        Swal.fire({
            icon: "error",
            title: "Error",
            text: 'Notification message must not be empty',
        });
    } else {
        // Reference to the Firestore document with the emailId as the document ID
        const docRef = db.collection("Notifications").doc(userEmail);

        // Update the document with the data
        return docRef.set({
            data: [message]
        }, { merge: true }) // Use merge to update the array field instead of replacing it
        .then(() => {
            Swal.fire({
                icon: "success",
                title: "Success",
                text: 'Notification sent successfully!',
            });
            document.getElementById("notify-user").value = "";
        })
        .catch((error) => {
            console.error(`Error inserting data: ${error}`);
        });
    }
}