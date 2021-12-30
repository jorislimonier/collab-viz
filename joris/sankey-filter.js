// Add element to select dropdown

/**
 Keep nodes of desired genres for links that inlude an album-related characteristics.
 */
export function makeGenreSelectOptions(genres) {
  const selectElementId = "genreSelect";
  var select = document.getElementById(selectElementId);
  genres.forEach(genre => {
    var option = document.createElement("option");
    option.value = genre; // dummy values to test, remove later
    option.innerHTML = genre; // dummy values to test, remove later
    select.appendChild(option);
  });
}

/**
Keep nodes of desired genres for links that inlude an album-related characteristics.
*/
export function filterByGenres(graph, genres) {
  const nodes = graph["nodes"];
  const links = graph["links"];

  const nodesToFilter = nodes // get number of nodes concerned by filtering
    .filter(({ name }) => name.includes("album"))
    .map((nodeGroup) => nodeGroup.node);

  var filteredLinks = links;
  // var filteredLinks = filteredLinks.filter(({ genre }) => genres.includes(genre));
  var filteredLinks = links.map((row) => {
    if (
      (nodesToFilter.includes(row.source) ||
        nodesToFilter.includes(row.target)) &&
      !genres.includes(row.genre)
    ) {
      row.value = 1;
    }
    return row;
  });

  console.log(filteredLinks[16]);
  var filteredGraph = { nodes: nodes, links: filteredLinks };
  return filteredGraph;
}
