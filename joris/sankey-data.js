const fs = require("fs");

var data = require("./sankey-genre.json");
var links = data["links"];

let genres = ["Acid Rock", "Acid Jazz", "Acid House", "Acid Techno", "Pop"];

var filteredGenres = links.filter(({ genre }) => genres.includes(genre));

var rock = links
  .filter(({ genre }) => genres.includes(genre))
  .reduce((sum, link) => sum + link["value"], 0);


var filteredData = { nodes: data["nodes"], links: filteredGenres };

const stringifiedData = JSON.stringify(filteredData, null, 2);


// Write to JSON
fs.writeFile("joris/sankey.json", stringifiedData, (err) => {
  if (err) {
    throw err;
  }
  console.log("Data successfully saved to JSON.");
});
