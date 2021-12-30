// Add element to select dropdown
var select = document.getElementById("genreSelect");
var option = document.createElement("option");
option.value = 3; // dummy values to test, remove later
option.innerHTML = 42; // dummy values to test, remove later
select.appendChild(option);

export function filterByGenres(graph, genres) {

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

  return filteredGraph;
}
