import { drawSankey } from "./sankey-builder.js";

/**
 * Fetch genres from the JSON file
 */
export let allGenres;

export function fetchUniqueGenres() {
  $.ajax({
    url: "sankey-genre.json",
    dataType: "json",
    async: false,
    success: function (data) {
      allGenres = [
        ...new Set(data.links.flatMap(({ genre }) => (genre ? [genre] : []))),
      ].sort();
    },
  });
}

/**
 Keep nodes of desired genres for links that inlude an album-related characteristics.
 */
export function makeGenreSelectOptions(genres) {
  const selectElementId = "genreSelect";
  var select = document.getElementById(selectElementId);

  // console.log(genres)
  genres.forEach((genre) => {
    var option = document.createElement("option");
    option.value = genre;
    option.innerHTML = genre;
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

  // group and sum selected genres
  var groupedLinks = [];
  filteredLinks.forEach((row) => {
    var sameSourceTarget = groupedLinks.filter(
      ({ source, target }) => source === row.source && target === row.target
    );
    if (true) {
      // check whether row.genre is null
      switch (sameSourceTarget.length) {
        case 0:
          // create entry of sameSourceTarget for this source and target
          groupedLinks.push({
            source: row.source,
            target: row.target,
            value: row.value,
          });
          break;
        case 1:
          // add row.value to summed entry of sameSourceTarget
          sameSourceTarget[0].value += row.value;
          break;
        default:
          console.log(`Unexpected length ${sameSourceTarget.length}`);
      }
    }
  });

  var filteredGraph = { nodes: nodes, links: groupedLinks };
  return filteredGraph;
}

export function genreSelectionListener(defaultGenres) {
  const selectElementId = "genreSelect";
  document.getElementById(selectElementId).addEventListener("change", () => {
    var filteredGenres = $("#" + selectElementId).val();
    // console.log(filteredGenres);
    if (filteredGenres.length == 0) {
      drawSankey(defaultGenres);
    } else {
      drawSankey(filteredGenres);
    }
  });
}
