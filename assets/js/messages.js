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

// To store user's data
let users = [];

// Store all notifications from DB 
let allNotifications = [];

// Store notifications based on the selected date
let selectedDateNotifications = [];

// Declare an array to store selected users
const selectedUsersArray = [];

// Pagination global variables
let thisPage = 1;
let limit = 2;
let records = [];

// Retrieve the data
function retrieveData() {
    db.collection("Users").get().then((querySnapshot) => {
        querySnapshot.forEach(doc => {
            users.push(doc.data());
        });
    });
}


// Function to perform live search
function liveSearch() {
    const searchInput = document.getElementById("search");
    const searchResults = document.getElementById("searchResults");
    const searchTerm = searchInput.value.toLowerCase();

    // Clear previous search results
    searchResults.innerHTML = "";

    // Filter users based on the search term
    const filteredUsers = users.filter(user => user.fullName.toLowerCase().includes(searchTerm));

    // Display search results
    filteredUsers.forEach(user => {
        const userDiv = document.createElement("div");
        userDiv.classList.add("user-result");
        // userDiv.classList.add("form-control");
        userDiv.textContent = user.fullName;
        // Add a click event listener to add the user to the selected list
        userDiv.addEventListener("click", () => {
            addUserToSelectedList(user);
        });
        searchResults.appendChild(userDiv);
    });
}

// Function to add a user to the selected list and array
function addUserToSelectedList(user) {
    const selectedUsers = document.getElementById("selectedUsers");
    const userDiv = document.createElement("div");
    userDiv.classList.add("selected-user");
    userDiv.classList.add("btn-warning");
    userDiv.textContent = user.fullName;

    // Add a click event listener to remove the user from the selected list
    userDiv.addEventListener("click", () => {
        removeUserFromSelectedList(user);
    });

    // Check if the user is already selected
    if (!isUserSelected(user)) {
        // Add the user to the selected list
        selectedUsers.appendChild(userDiv);
        // Add the user to the selected users array
        selectedUsersArray.push(user);
    }
}

// Function to remove a user from the selected list and array
function removeUserFromSelectedList(user) {
    const selectedUsers = document.getElementById("selectedUsers");
    const userDivs = selectedUsers.getElementsByClassName("selected-user");

    // Find and remove the user's div from the selected list
    for (let i = 0; i < userDivs.length; i++) {
        const userDiv = userDivs[i];
        if (userDiv.textContent === user.fullName) {
            selectedUsers.removeChild(userDiv);
            // Remove the user from the selected users array
            selectedUsersArray.splice(selectedUsersArray.indexOf(user), 1);
            break;
        }
    }
}

// Function to check if a user is already selected
function isUserSelected(user) {
    return selectedUsersArray.some(selectedUser => selectedUser.fullName === user.fullName);
}


// Reloading the page
function reloadPage() {
    location.reload();
}


// Add an event listener to the button
document.getElementById("sendNotificationBtn").addEventListener("click", sendNotification);

function sendNotification() {
    // Notification message
    const title = document.getElementById("title").value;
    const message = document.getElementById("notification").value;

    // Getting the selected users
    const selectedUsers = document.getElementById("selectedUsers");

    if (message == "") {
        Swal.fire({
            icon: "error",
            title: "Error",
            text: 'Message must not be empty',
        });
    } else if (selectedUsersArray.length == 0) {
        Swal.fire({
            icon: "error",
            title: "Error",
            text: 'Select a partner seek to notify',
        });
    } else {
        const date = new Date(); // Get the current date and time
        // Extract the date portion (year, month, day)
        const year = date.getFullYear();
        const month = (date.getMonth() + 1).toString().padStart(2, '0'); // Months are zero-based, so add 1
        const day = date.getDate().toString().padStart(2, '0');
        // Combine the date components to create the document ID (e.g., "2023-10-07")
        const dateId = `${year}-${month}-${day}`;

        // Data to store in th firestore (Announcement + Date posted)
        const notifications = {
            title: title,
            message: message,
            users: selectedUsersArray,
            date: dateId
        };

        // Reference to the Firestore document with the date posted as the document ID
        const docRef = db.collection("Notifications").doc(dateId);

        // Update the document with the data
        return docRef.update({
            notifications: firebase.firestore.FieldValue.arrayUnion(notifications),
        })
            .then(() => {
                return Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: 'Message sent successfully!',
                });
            })
            .then((result) => {
                if (result.isConfirmed) {
                    // Reload the page when the user clicks "OK"     
                    location.reload();
                }
            })
            .catch((error) => {
                console.error(`Error sending Notification: ${error}`);
            });
    }

    // Reload the page when the button is clicked
    window.location.reload();
}

// Display the data from Firestore
function readNotificationsFromDB() {
    // Reference to the Firestore collection
    const collectionRef = db.collection("Notifications");

    // Query the collection (e.g., get all documents)
    collectionRef
        .get()
        .then((querySnapshot) => {
            // Check if there are any documents in the collection
            if (querySnapshot.empty) {
                console.log('No documents found in the collection.');
                return;
            }

            // Loop through the documents in the collection
            querySnapshot.forEach((doc) => {
                const data = doc.data();

                // Storing all the announcements in an array
                data["notifications"].forEach((record) => {
                    allNotifications.push({
                        date: record.date,
                        message: record.message,
                        title: record.title,
                        users: record.users
                    });
                });
            });
            displayNotifications(true);
        })
        .catch((error) => {
            console.error('Error fetching data: ', error);
        });
}

// Function to display the notifications
function displayNotifications(flag) {
    // flag - true, then all notifications
    // flag - false, then selected notifications based on date
    if (flag) {
        // Clearing the records array
        while (records.length > 0) {
            records.pop();
        }

        // Pushing all the notifications into records
        allNotifications.forEach((r) => {
            records.push(r);
        });

        loadNotification();
    } else {
        // Clearing the records array
        while (records.length > 0) {
            records.pop();
        }

        // Pushing selected elements the notifications into records
        selectedDateNotifications.forEach((r) => {
            records.push(r);
        });

        loadNotification();
    }
}

// Function to create a card element for each notification
function createCard(element) {
    const container = document.getElementById('notification-container'); // Replace with your container's ID
    // Create a link (a card) for each element in the Firestore document
    const cardLink = document.createElement('a');
    cardLink.href = '#';
    cardLink.classList.add('list-group-item', 'list-group-item-action');

    // Create the card content
    const cardContent = document.createElement('div');
    cardContent.classList.add('d-flex', 'w-100', 'justify-content-between');

    // Create the title element
    const title = document.createElement('h5');
    title.classList.add('mb-1');
    title.textContent = element.title;

    // Create the noOfDays element
    const noOfDays = document.createElement('small');
    noOfDays.classList.add('text-body-secondary');
    noOfDays.textContent = daysDifference(element.date);

    // Create the message element
    const message = document.createElement('p');
    message.classList.add('mb-1');
    message.textContent = element.message;

    // Create the users element
    const usersList = document.createElement('small');
    usersList.textContent = "Notified: ";
    element["users"].forEach((user) => {
        usersList.textContent += user.fullName;
        usersList.textContent += ", ";
    })


    // Append elements to the card content
    cardContent.appendChild(title);
    cardContent.appendChild(noOfDays);

    // Append card content to the card link
    cardLink.appendChild(cardContent);
    cardLink.appendChild(message);
    cardLink.appendChild(usersList);

    // Append the card link to the container
    container.appendChild(cardLink);
    container.appendChild(document.createElement('br'));
}

// Calculate the date difference in days
function daysDifference(date) {
    // Create a Date object for the current date
    const currentDate = new Date();

    // Create a Date object for the other date you want to compare
    const otherDate = new Date(date);

    // Calculate the time difference in milliseconds
    const timeDifference = currentDate - otherDate;

    // Calculate the number of days
    const daysDifference = Math.floor(timeDifference / (1000 * 60 * 60 * 24));

    if (daysDifference == 0) {
        return "Today";
    } else if (daysDifference == 1) {
        return "Yesterday";
    } else {
        return `${daysDifference} days ago`;
    }
}

// Initialize FullCalendar when the button is clicked
document.getElementById("showCalendarButton").addEventListener("click", function () {
    // Show the calendar modal when the button is clicked
    showCalendarModal();
});


// Function to show the calendar modal when the "Pick a Date" button is clicked
function showCalendarModal() {
    $('#calendarModal').modal('show'); // Show the calendar modal
}

// Initialize FullCalendar when the modal is shown
$('#calendarModal').on('shown.bs.modal', function () {
    const calendarEl = document.getElementById("calendar");
    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth", // Set the initial view mode
        selectable: true, // Allow date selection
        dateClick: function (info) {
            // Handle date selection here
            const selectedDate = info.dateStr;

            // Get the data from firestore based on selected date
            notificationsOnSelectedDate(selectedDate);

            // Close the calendar modal
            $('#calendarModal').modal('hide');
        },
    });

    // Render the calendar
    calendar.render();
});

// Retrieving notifications on a particular date from DB
function notificationsOnSelectedDate(date) {

    // Deleting all elements for every fresh reload
    while (selectedDateNotifications.length > 0) {
        selectedDateNotifications.pop();
    }
    // Reference to the Firestore document with the same ID as the selected date
    const docRef = db.collection("Notifications").doc(date);

    // Fetch data from Firestore based on the selected date
    docRef.get()
        .then((doc) => {
            if (doc.exists) {
                // Data found for the selected date
                const data = doc.data();

                // Storing the selected date notifications in an array
                data["notifications"].forEach((record) => {
                    selectedDateNotifications.push({
                        date: record.date,
                        message: record.message,
                        title: record.title,
                        users: record.users
                    });
                });

                // Get a reference to the div element
                const notificationContainer = document.getElementById("notification-container");

                // Remove all child elements within the div
                while (notificationContainer.firstChild) {
                    notificationContainer.removeChild(notificationContainer.firstChild);
                }
                displayNotifications(false);

            } else {
                // No data found for the selected date
                const dataContainer = document.getElementById("notification-container");
                dataContainer.innerHTML = `<p>No data found for ${date}.</p>`;
            }
        })
        .catch((error) => {
            console.error("Error fetching data:", error);
        });
}


// Pagination Code
function loadNotification() {
    let beginIndex = limit * (thisPage - 1);
    let endIndex = limit * thisPage - 1;

    // Clear the container before adding new records
    const container = document.getElementById('notification-container');
    container.innerHTML = "";

    records.forEach((record, index) => {
        if (index >= beginIndex && index <= endIndex) {
            createCard(record);
        }
    });
    listPage();
}

function listPage() {
    let count = Math.ceil(records.length / limit);
    document.querySelector('.listPage').innerHTML = "";

    if (thisPage != 1) {
        let prev = document.createElement("li");
        prev.innerHTML = "Prev";
        prev.setAttribute("onclick", "changePage(" + (thisPage - 1) + ")");
        document.querySelector(".listPage").appendChild(prev);
    }

    for (i = 1; i <= count; i++) {
        let newPage = document.createElement("li");
        newPage.innerHTML = i;
        if (i == thisPage) {
            newPage.classList.add('active');
        }
        newPage.setAttribute("onclick", "changePage(" + i + ")");
        document.querySelector(".listPage").appendChild(newPage);
    }
}

function changePage(i) {
    thisPage = i;
    loadNotification();
}

// Attach the event listener to the "DOMContentLoaded" event
document.addEventListener("DOMContentLoaded", function () {
    // Call the function when the page is fully loaded
    retrieveData();
    readNotificationsFromDB();
});
