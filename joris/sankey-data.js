const fs = require("fs");

var data = require("./sankey-genre.json");
var nodes = data["nodes"];
var links = data["links"];

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
    // console.log(row);
  } else {
    // console.log(row);
  }
  delete row.genre;
  return row;
});

console.log(filteredGenres.slice(0, 20));

var filteredData = { nodes: data["nodes"], links: filteredGenres };
//
//
//
//
//
//

// Write to JSON
const stringifiedData = JSON.stringify(filteredData, null, 2);
fs.writeFile("joris/sankey.json", stringifiedData, (err) => {
  if (err) {
    throw err;
  }
  console.log("\n\n--> Data successfully saved to JSON.");
});
