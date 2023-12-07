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

// Storeall announcements in DB
let allAnnouncements = [];

// Store announcements based on the selected date
let selectedDateAnnouncements = [];

// Pagination global variables
let thisPage = 1;
let limit = 2;
let records = [];

// Display the data from Firestore
function readAnnouncementsFromDB() {
    // Reference to the Firestore collection
    const collectionRef = db.collection("Announcements");

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
                data["announcements"].forEach((record) => {
                    allAnnouncements.push({
                        date: record.date,
                        message: record.message,
                        title: record.title
                    });
                });
            });
            displayAnnouncements(true);
        })
        .catch((error) => {
            console.error('Error fetching data: ', error);
        });
}

// Attach the event listener to the "DOMContentLoaded" event
document.addEventListener("DOMContentLoaded", function () {
    // Call the function when the page is fully loaded
    readAnnouncementsFromDB();
});


// Function to display the announcements
function displayAnnouncements(flag) {
    // flag - true, then all announcements
    // flag - false, then selected announcements based on date
    if (flag) {
        // Clearing the records array
        while (records.length > 0) {
            records.pop();
        }

        // Pushing all the announcements into records
        allAnnouncements.forEach((r) => {
            records.push(r);
        });

        loadAnnouncement();
    } else {
        // Clearing the records array
        while (records.length > 0) {
            records.pop();
        }

        // Pushing selected elements the announcements into records
        selectedDateAnnouncements.forEach((r) => {
            records.push(r);
        });

        loadAnnouncement();
    }
}

// Add an event listener to the button
document.getElementById("postAnnouncementBtn").addEventListener("click", postAnnouncement);

function postAnnouncement() {
    // Announcement message
    const title = document.getElementById("title").value;
    const message = document.getElementById("announcement").value;

    if (message == "") {
        Swal.fire({
            icon: "error",
            title: "Error",
            text: 'Announcement message must not be empty',
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
        const announcements = {
            title: title,
            message: message,
            date: dateId
        };

        // Reference to the Firestore document with the date posted as the document ID
        const docRef = db.collection("Announcements").doc(dateId);

        // Update the document with the data
        return docRef.update({
            announcements: firebase.firestore.FieldValue.arrayUnion(announcements),
        })
            .then(() => {
                return Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: 'Announcement posted successfully!',
                });
            })
            .then((result) => {
                if (result.isConfirmed) {
                    // Reload the page when the user clicks "OK"     
                    location.reload();
                }
            })
            .catch((error) => {
                console.error(`Error posting announcement: ${error}`);
            });
    }

    // Reload the page when the button is clicked
    window.location.reload();
}


// Function to create a card element for each announcement
function createCard(element) {
    const container = document.getElementById('announcement-container'); // Replace with your container's ID
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

    // Append elements to the card content
    cardContent.appendChild(title);
    cardContent.appendChild(noOfDays);

    // Append card content to the card link
    cardLink.appendChild(cardContent);
    cardLink.appendChild(message);

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
            announementsOnSelectedDate(selectedDate);

            // Close the calendar modal
            $('#calendarModal').modal('hide');
        },
    });

    // Render the calendar
    calendar.render();
});


// Retrieving announcements on a particular date from DB
function announementsOnSelectedDate(date) {

    // Deleting all elements for every fresh reload
    while (selectedDateAnnouncements.length > 0) {
        selectedDateAnnouncements.pop();
    }

    // Reference to the Firestore document with the same ID as the selected date
    const docRef = db.collection("Announcements").doc(date);

    // Fetch data from Firestore based on the selected date
    docRef.get()
        .then((doc) => {
            if (doc.exists) {
                // Data found for the selected date
                const data = doc.data();

                // Storing the selected date announcements in an array
                data["announcements"].forEach((record) => {
                    selectedDateAnnouncements.push({
                        date: record.date,
                        message: record.message,
                        title: record.title
                    });
                });

                // Get a reference to the div element
                const announcementContainer = document.getElementById("announcement-container");

                // Remove all child elements within the div
                while (announcementContainer.firstChild) {
                    announcementContainer.removeChild(announcementContainer.firstChild);
                }
                displayAnnouncements(false);

            } else {
                // No data found for the selected date
                const dataContainer = document.getElementById("announcement-container");
                dataContainer.innerHTML = `<p>No data found for ${date}.</p>`;
            }
        })
        .catch((error) => {
            console.error("Error fetching data:", error);
        });
}


// Pagination Code
function loadAnnouncement() {
    let beginIndex = limit * (thisPage - 1);
    let endIndex = limit * thisPage - 1;

    // Clear the container before adding new records
    const container = document.getElementById('announcement-container');
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
    loadAnnouncement();
}