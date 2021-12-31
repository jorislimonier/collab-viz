// Add element to select dropdown

/**
 Keep nodes of desired genres for links that inlude an album-related characteristics.
 */
export function makeGenreSelectOptions(genres) {
  const selectElementId = "genreSelect";
  var select = document.getElementById(selectElementId);
  genres.forEach((genre) => {
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

  const nodesToFilter = nodes // get index of nodes concerned by filtering
    .filter(({ name }) => name.includes("album"))
    .map((nodeGroup) => nodeGroup.node);

  var filteredLinks = links;
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

  var uniqueSources = [
    ...new Set(links.flatMap(({ source }) => (source == null ? [] : [source]))),
  ].sort();

  var groupedLinks = [];
  links.forEach((row) => {
    var sameSourceTarget = groupedLinks.filter(
      ({ source, target }) => source === row.source && target === row.target
    );
    switch (sameSourceTarget.length) {
      case 0:
        groupedLinks.push({
          source: row.source,
          target: row.target,
          value: row.value,
        });
        break;
      case 1:
        sameSourceTarget[0].value += row.value;
        break;
      default:
        console.log(`Unexpected length ${sameSourceTarget.length}`);
    }
  });

  console.log(groupedLinks);

  var filteredGraph = { nodes: nodes, links: groupedLinks };
  return filteredGraph;
}
