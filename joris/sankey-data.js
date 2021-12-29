/*
 *Write to JSON
 */
function writeJSON() {
  const stringifiedData = JSON.stringify(filteredData, null, 2);
  fs.writeFile("joris/sankey.json", stringifiedData, (err) => {
    if (err) {
      throw err;
    }
    console.log("\n\n--> Data successfully saved to JSON.");
  });
}
//
//
//
//
//

// Add element to select dropdown
var select = document.getElementById("genreSelect");
var option = document.createElement("option");
option.value = 3;
option.innerHTML = 4;
select.appendChild(option);

const data = fetch("./sankey-genre.json")
.then((response) => response.json())
.then((data) => console.log(data));
const fs = require("fs");
const nodes = data["nodes"];
const links = data["links"];

var genres = ["Acid Rock", "Acid Jazz", "Acid House", "Acid Techno", "Pop"];

const nodesToFilter = nodes
  .filter(({ name }) => name.includes("album"))
  .map((nodeGroup) => nodeGroup.node);

console.log(nodesToFilter);

var filteredGenres = links;
// var filteredGenres = filteredGenres.filter(({ genre }) => genres.includes(genre));

var filteredGenres = links.slice(0, 99).map((row) => {
  if (
    (nodesToFilter.includes(row.source) ||
      nodesToFilter.includes(row.target)) &&
    !genres.includes(row.genre)
  ) {
    row.value = 0;
  }
  delete row.genre;
  return row;
});

console.log(filteredGenres.slice(0, 20));

var filteredData = { nodes: data["nodes"], links: filteredGenres };

writeJSON();
