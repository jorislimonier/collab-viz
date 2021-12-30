// Add element to select dropdown
var select = document.getElementById("genreSelect");
var option = document.createElement("option");
option.value = 3; // dummy values to test, remove later
option.innerHTML = 42; // dummy values to test, remove later
select.appendChild(option);

var data = fetch("./sankey-genre.json")
  .then((response) => response.json())
  .then((data) => console.log(data));


export function dummyFunc(){
  console.log("EXPORT WORKED")
}