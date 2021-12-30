// Add element to select dropdown
var select = document.getElementById("genreSelect");
var option = document.createElement("option");
option.value = 3; // dummy values to test, remove later
option.innerHTML = 42; // dummy values to test, remove later
select.appendChild(option);

/**
Keep nodes of desired genres for links that inlude an album-related characteristics.
*/
export function filterByGenres(graph, genres) {
  console.log(graph["links"]);
  const nodes = graph["nodes"];
  const links = graph["links"];

  const nodesToFilter = nodes // get number of nodes concerned by filtering
    .filter(({ name }) => name.includes("album"))
    .map((nodeGroup) => nodeGroup.node);

  var filteredLinks = links;
  // var filteredLinks = filteredLinks.filter(({ genre }) => genres.includes(genre));
  console.log(links.slice(379, 381));
  var filteredLinks = links.map((row) => {
    if (
      (nodesToFilter.includes(row.source) ||
        nodesToFilter.includes(row.target)) &&
      !genres.includes(row.genre)
    ) {
      console.log("Setting row.value to 0");
      row.value = 1;
    }
    // delete row.genre;
    return row;
  });
  // console.log(filteredLinks)
  var filteredGraph = { nodes: nodes, links: filteredLinks };
  console.log(filteredGraph["links"]);
  return filteredGraph;
}
