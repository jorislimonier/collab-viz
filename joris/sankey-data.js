// Add element to select dropdown
var select = document.getElementById("genreSelect");
var option = document.createElement("option");
option.value = 3; // dummy values to test, remove later
option.innerHTML = 42; // dummy values to test, remove later
select.appendChild(option);

var data = fetch("./sankey-genre.json")
  .then((response) => response.json())
  .then((data) => console.log(data));


export function filterByGenres(graph, genres) {
  console.log("a", graph);

  const nodes = graph["nodes"];
  const links = graph["links"];

  const nodesToFilter = nodes
    .filter(({ name }) => name.includes("album"))
    .map((nodeGroup) => nodeGroup.node);

  var filteredLinks = links;
  // var filteredLinks = filteredLinks.filter(({ genre }) => genres.includes(genre));

  var filteredLinks = links.slice(0, 99).map((row) => {
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

  var filteredGraph = { nodes: nodes, links: filteredLinks };
  console.log(filteredGraph);

  return filteredGraph;
}