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

// Function to fetch and display registered users count
function displayUsersCount() {
    db.collection("Users").get()
        .then((querySnapshot) => {
            const count = querySnapshot.size; // Get the count of documents
            const countElement = document.getElementById("usersCount");
            countElement.textContent = `${count}`;
        })
        .catch((error) => {
            console.error("Error getting documents: ", error);
        });
}

// Function to fetch and male users count
function displayMaleUsersCount() {
    db.collection("Users")
        .where("gender", "==", "Male") // Add a filter for male users
        .get()
        .then((querySnapshot) => {
            const count = querySnapshot.size; // Get the count of documents
            const countElement = document.getElementById("maleUsersCount");
            countElement.textContent = `${count}`;
        })
        .catch((error) => {
            console.error("Error getting documents: ", error);
        });
}

// Function to fetch and female users count
function displayFemaleUsersCount() {
    db.collection("Users")
        .where("gender", "==", "Female") // Add a filter for female users
        .get()
        .then((querySnapshot) => {
            const count = querySnapshot.size; // Get the count of documents
            const countElement = document.getElementById("femaleUsersCount");
            countElement.textContent = `${count}`;
        })
        .catch((error) => {
            console.error("Error getting documents: ", error);
        });
}

// Call the function to display the record count when the page loads
window.onload = () => {
    displayUsersCount();
    displayMaleUsersCount();
    displayFemaleUsersCount();
};