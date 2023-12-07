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

// array to store the data
let users = [];
let usersToDisplay = [];
let filteredAndSortedUsers = [];
let searchText = "";
let sortBy = "";


// Variables for pagination
const itemsPerPage = 25; // Number of items to display per page
let currentPage = 1; // Current page number

// Retrieve the data
function retrieveData() {
    db.collection("Users").get().then((querySnapshot) => {

        querySnapshot.forEach(doc => {
            users.push(doc.data());
        });
        displayData(users);
    });
}

// Retrieve the Real-time data
function retrieveRealTimeData() {
    db.collection("Users").onSnapshot((querySnapshot) => {
        querySnapshot.forEach(doc => {
            users.push(doc.data());
        });
        displayData(users);
    });
}

// Displaying the data into table
var sno = 0;
var tbody = document.getElementById("registered-users");

// Create each row
function displayEachRow(name, email, likesCount, reportsCount) {
    // Creating table row
    var trow = document.createElement("tr");

    // Creating table cells
    var td_1 = document.createElement("td");
    var td_2 = document.createElement("td");
    var td_3 = document.createElement("td");
    var td_4 = document.createElement("td");
    var td_5 = document.createElement("td");
    var td_6 = document.createElement("td");

    // Adding data to table cells
    td_1.innerHTML = ++sno;
    td_2.innerHTML = name;
    td_3.innerHTML = email;
    td_4.innerHTML = likesCount;
    td_5.innerHTML = reportsCount;

    // Creating the "View Profile" button
    var viewProfileButton = document.createElement("button");
    viewProfileButton.textContent = "View Profile";
    viewProfileButton.classList.add("btn", "btn-sm", "btn-primary");

    // Add a data attribute to the button to store the user's email
    viewProfileButton.setAttribute("data-user-email", email);

    // Add an event listener to the button
    viewProfileButton.addEventListener("click", viewProfile);

    // Append the button to the table cell
    td_6.appendChild(viewProfileButton);

    // Append table cells to row
    trow.appendChild(td_1);
    trow.appendChild(td_2);
    trow.appendChild(td_3);
    trow.appendChild(td_4);
    trow.appendChild(td_5);
    trow.appendChild(td_6);

    // Append table row to body
    tbody.appendChild(trow);
}


// Display all rows to the table
function displayData(usersData) {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;

    // Get the users to display on the current page
    usersToDisplay = usersData.slice(startIndex, endIndex);

    sno = 0;
    tbody.innerHTML = "";
    usersToDisplay.forEach(element => {
        displayEachRow(element.fullName, element.email, element.likes, element.reports);
    });

    // Update pagination controls
    listPage();
}

// Call displayUsers with the initial data
window.onload = () => {
    retrieveData(); // Assuming retrieveData populates the `users` array
    displayData(users); // Display the initial data with pagination
};

function listPage() {
    let count = Math.ceil(users.length / itemsPerPage);
    document.querySelector('.listPage').innerHTML = "";

    if (currentPage != 1) {
        let prev = document.createElement("li");
        prev.innerHTML = "Prev";
        prev.setAttribute("onclick", "changePage(" + (currentPage - 1) + ")");
        document.querySelector(".listPage").appendChild(prev);
    }

    for (i = 1; i <= count; i++) {
        let newPage = document.createElement("li");
        newPage.innerHTML = i + " - " + (itemsPerPage * i);
        if (i == currentPage) {
            newPage.classList.add('active');
        }
        newPage.setAttribute("onclick", "changePage(" + i + ")");
        document.querySelector(".listPage").appendChild(newPage);
    }

    if (currentPage < count) {
        // Create a "Next" button
        const nextButton = document.createElement("li");
        nextButton.innerHTML = "Next";
        nextButton.setAttribute("onclick", "changePage(" + (currentPage + 1) + ")");
        document.querySelector(".listPage").appendChild(nextButton);
    }
}

function changePage(i) {
    currentPage = i;
    if (searchText || sortBy) {
        // If there is an active search or sort, display search/sort results
        displayData(filteredAndSortedUsers);
    } else {
        // Otherwise, display the initial users
        displayData(users);
    }
}

// Display user details in the profile page
function viewProfile(event) {
    // Retrieve the user's email from the data attribute
    var userEmail = event.target.getAttribute("data-user-email");

    // Now, you can use the userEmail to navigate to the user's profile or perform any other action
    console.log("View profile for user with email:", userEmail);

    // Construct the URL of the profile page using the user's email
    var profilePageUrl = `view-profile.html?email=${encodeURIComponent(userEmail)}`;

    // Navigate to the profile page
    window.location.href = profilePageUrl;
}


// Search input field
const searchInput = document.getElementById("search-input");

// Sort select dropdown
const sortSelect = document.getElementById("sort-select");

// Search button
const searchButton = document.getElementById("search-button");

// Event listener for search button
searchButton.addEventListener("click", () => {
    performSearchAndSort();
});

// Event listener for search input (optional)
searchInput.addEventListener("input", () => {
    performSearchAndSort();
});

// Event listener for sort select
sortSelect.addEventListener("change", () => {
    performSearchAndSort();
});

// Function to perform search and sort
function performSearchAndSort() {
    searchText = searchInput.value.toLowerCase();
    sortBy = sortSelect.value;

    // Apply search filter
    const filteredUsers = users.filter((user) => {
        return user.fullName.toLowerCase().includes(searchText);
    });

    // Apply filtering based on gender if "Male" or "Female" option is selected
    filteredAndSortedUsers = filteredUsers;
    if (sortBy === "male") {
        filteredAndSortedUsers = filteredUsers.filter((user) => user.gender === "Male");
    } if (sortBy === "female") {
        filteredAndSortedUsers = filteredUsers.filter((user) => user.gender === "Female");
    }

    // Apply sorting
    let sortedUsers = [];
    switch (sortBy) {
        case "likes":
            sortedUsers = filteredAndSortedUsers.sort((a, b) => b.likes - a.likes);
            break;
        case "reports":
            sortedUsers = filteredAndSortedUsers.sort((a, b) => b.reports - a.reports);
            break;
        default:
            // Default sorting logic (by name)
            sortedUsers = filteredAndSortedUsers.sort((a, b) => a.fullName.localeCompare(b.fullName));
    }

    // Display the filtered and sorted data
    displayData(sortedUsers);
}

