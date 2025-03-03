function showOptionsPanel(country) {
  // Hide all options panels
  var allOptions = document.querySelectorAll('.options');
  allOptions.forEach(function (option) {
    option.style.display = 'none';
  });

  // Show the options panel for the selected country
  var optionsPanel = document.getElementById(country + '-options');
  if (optionsPanel) {
    optionsPanel.style.display = 'block';
  }
}

// Function to go back to View 1
function goBack() {
  resetViews();
  hideViews();
  showView1();
}

function showView1() {
  var view1 = document.getElementById("view1");
  view1.style.display = "block";
}
// JavaScript function to reset View 1 and View 2

function resetViews() {
  var radioButtons = document.querySelectorAll('.tab input[type="radio"]');
  radioButtons.forEach(function (button) {
    button.checked = false;
  });

}

function hideViews() {

  // Hide options panels
  var optionsPanels = document.querySelectorAll('.options');
  optionsPanels.forEach(function (panel) {
    panel.style.display = "none";
  });
}


// JavaScript function to get the selected registration
function getSelectedRegistration(optionsId) {
  var selectedRegistrations = [];
  var inputs = document.querySelectorAll('#' + optionsId + ' input:checked');
  inputs.forEach(function (input) {
    if (input.type === 'checkbox' || input.type === 'radio') {
      selectedRegistrations.push(input.value);
    }
  });
  return selectedRegistrations.join(', ');
}

function saveRegistration(country, registration) {
  var selectedRegistrationsDiv = document.getElementById("selected-registrations");

  // Check if an element with the given ID already exists
  var existingInput = document.getElementById(country + "_registration");

  if (existingInput) {
    // If the element exists, update its value
    existingInput.value = registration;
  } else {
    // If the element doesn't exist, create a new one
    // Create .elem-group div
    var newRegistrationDiv = document.createElement("div");
    newRegistrationDiv.classList.add("elem-group");
    newRegistrationDiv.classList.add("inlined-big"); // Add inlined-big class

    // Create label
    var registrationLabel = document.createElement("label");
    registrationLabel.innerText = "Registration for " + country;
    // Create readonly input element
    const readOnlyInput = document.createElement("input");
    readOnlyInput.id = country + "_registration";
    readOnlyInput.setAttribute("name", country + "_registration");
    readOnlyInput.type = "text";
    readOnlyInput.value = registration;
    readOnlyInput.readOnly = true; // Make the input readonly
    readOnlyInput.classList.add("selected-registration-input");

    // Append elements to .elem-group div
    newRegistrationDiv.appendChild(registrationLabel);
    newRegistrationDiv.appendChild(readOnlyInput);

    // Create delete button div
    var deleteButtonDiv = document.createElement("div");
    deleteButtonDiv.classList.add("elem-group");
    deleteButtonDiv.classList.add("inlined-small"); // Add inlined-small class

    // Create delete button
    var deleteButton = document.createElement("button");
    deleteButton.className = "delete-button-no-span";
    deleteButton.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
        </svg>
    `;
    deleteButton.type = "button";
    deleteButton.onclick = function () {
      // Remove the parent div when the delete button is clicked
      selectedRegistrationsDiv.removeChild(newRegistrationDiv);
      selectedRegistrationsDiv.removeChild(deleteButtonDiv);

    };

    // Append delete button to the delete button div
    deleteButtonDiv.appendChild(deleteButton);

    // Append deleteButtonDiv to newRegistrationDiv
    // newRegistrationDiv.appendChild(deleteButtonDiv);

    // Add newRegistrationDiv to selectedRegistrationsDiv
    selectedRegistrationsDiv.appendChild(newRegistrationDiv);

    selectedRegistrationsDiv.appendChild(deleteButtonDiv);

  }

  resetViews();
  hideViews();
}





function checkAndCreateRegistrations() {
  // Define an object with country registrations
  var countryRegistrations = {
    "Belgium": carData.belgium_reg,
    "Bulgaria": carData.bulgaria_reg,
    "Denmark": carData.denmark_reg,
    "France": carData.france_reg,
    "Germany": carData.germany_reg,
    "Greece": carData.greece_reg,
    "Netherlands": carData.netherlands_reg,
    "Norway": carData.norway_reg,
    "Poland": carData.poland_reg,
    "Spain": carData.spain_reg,
    "United-kingdom": carData.uk_reg
  };

  console.log("carData: ", carData); // Log the entire carData object

  console.log("countryRegistrations: ", countryRegistrations); // Log the countryRegistrations object

  // Iterate over country registrations
  for (var country in countryRegistrations) {
    var countryReg = countryRegistrations[country];
    // Check if the registration is not null
    if (countryReg !== null && countryReg !== "") {
      console.log("Country reg" + countryReg)
      // Call saveRegistration function to handle registration creation/updating
      saveRegistration(country, countryReg);
    }
  }
}












function deleteNote(noteId) {
  fetch("/delete-note", {
    method: "POST",
    body: JSON.stringify({ noteId: noteId }),
  }).then((_res) => {
    window.location.href = "/";
  });
}

/* script.js */

/* Function to toggle the visibility of the options menu */
function toggleMenu(menuId) {
  const options = document.getElementById(menuId);
  options.style.display = options.style.display === 'none' ? 'block' : 'none';
}