import tablesort from 'tablesort';

import initGlobalSearchForm from 'administrate/global_search/form';

const GLOBAL_SEARCH_URL = `/assets/global_search`;
const USER_VIEW_URL = id => `/admin/users/${id}`;
const ASSET_VIEW_URL = id => `/admin/assets/${id}`;
const LOCATION_VIEW_URL = id => `/admin/locations/${id}`;

const initSearchIndex = () => {
  const $results = $('#search-results__body');
  const $welcomeScreen = $('#welcome-screen');
  const $noResultsScreen = $('#no-results-screen');

  const { getFormState } = initGlobalSearchForm(submitSearch);

  // Table sorting & related styling
  const tableElem = document.getElementById('search-results');
  const tableSorter = tablesort(tableElem);
  tableElem.addEventListener('afterSort', () => {
    $('.cell-label .cell-label__sort-indicator').remove();

    $('.cell-label[aria-sort="ascending"]').append(`
      <span
        class="cell-label__sort-indicator cell-label__sort-indicator--asc"
      >
        <svg aria-hidden="true">
          <use xlink:href="#icon-up-caret" />
        </svg>
      </span>
    `);
    $('.cell-label[aria-sort="descending"]').append(`
      <span
        class="cell-label__sort-indicator cell-label__sort-indicator--desc"
      >
        <svg aria-hidden="true">
          <use xlink:href="#icon-up-caret" />
        </svg>
      </span>
    `);
  });

  function submitSearch(formState) {
    clearResults();
    $.post(GLOBAL_SEARCH_URL, formState)
      .then(results => {
        renderPage(!!results);
        if (results) {
          renderResults(results);
          tableSorter.refresh();
        }
      })
      .catch(e => {
        console.error('Error while searching:\n', e);
        renderPage(false);
      });
  }

  function clearResults() {
    $results.empty();
  }

  function renderResults(results) {
    const { assets, locations, users, tags } = results;

    assets.forEach(asset => {
      const user = users.find(({ id }) => id === asset.user_id);
      const location = locations.find(({ id }) => id === asset.location_id);
      const primaryTag = tags.find(({ name }) => name === asset.tag_list[0]);

      $results.append(`
        <tr class="js-table-row">
          <td
            class="cell-data cell-data--tag"
            data-sort="${primaryTag?.name || ''}"
          >
            ${
              primaryTag
                ? `
                  <span
                    class="asset-tag__color-dot"
                    title="${primaryTag.name}"
                    style="background-color: ${primaryTag.color}"
                  >
                    &nbsp;
                  </span>
                `
                : ''
            }
          </td>

          <td class="cell-data cell-data--asset-name">
            <a href="${ASSET_VIEW_URL(asset.id)}">
              ${asset.name}
            </a>
          </td>

          <td class="cell-data cell-data--user">
            ${
              user
                ? `
              <a href="${USER_VIEW_URL(user.id)}">
                ${user.display_name || user.email}
              </a>
            `
                : ''
            }
          </td>

          <td class="cell-data cell-data--location">
            ${
              location
                ? `
              <a href="${LOCATION_VIEW_URL(location.id)}">
                ${location.name}
              </a>
            `
                : ''
            }
          </td>
        </tr>
      `);
    });
  }

  // Render either results table, welcome screen, or "no results" screen
  function renderPage(hasResults) {
    if (hasResults) {
      $welcomeScreen.css('display', 'none');
      $noResultsScreen.css('display', 'none');
      tableElem.style.display = 'table';
    } else {
      tableElem.style.display = 'none';

      const { query, filters } = getFormState();

      if (query.length === 0 && Object.keys(filters).length === 0) {
        $noResultsScreen.css('display', 'none');
        $welcomeScreen.css('display', 'flex');
      } else {
        $welcomeScreen.css('display', 'none');
        $noResultsScreen.css('display', 'flex');
      }
    }
  }
};

export default initSearchIndex;
