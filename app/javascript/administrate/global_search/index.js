import { useMemo } from 'preact/hooks';
import Select from 'react-select';

import useGlobalSearchForm from 'administrate/global_search/useGlobalSearchForm';

const GLOBAL_SEARCH_URL = `/assets/global_search`;
const USER_VIEW_URL = id => `/admin/users/${id}`;
const ASSET_VIEW_URL = id => `/admin/assets/${id}`;
const LOCATION_VIEW_URL = id => `/admin/locations/${id}`;

const GlobalSearchIndex = () => {
  const { query, filters } = useGlobalSearchForm();

  // These are all populated by rails template views/admin/search/index.html.erb,
  // no async data loading so no dependencies should be safe.
  const tagOptions = useMemo(() => {}, []);
  const heldByOptions = useMemo(() => {}, []);
  const locationOptions = useMemo(() => {}, []);

  return (
    <div>
      <header class="main-content__header" role="banner">
        <form class="search global-search__form" role="search">
          <div class="global-search__form__query-bar">
            <label class="search__label" for="search">
              <svg class="search__eyeglass-icon" role="img">
                <title>Filter asset names</title>
                <use href="#icon-eyeglass"></use>
              </svg>
            </label>

            <input
              class="search__input global-search__input"
              id="search"
              type="search"
              name="search"
              placeholder="Filter asset names"
              value=""
            />

            <a
              class="search__clear-link global-search__form__clear-btn"
              href="/admin/search"
            >
              <svg class="search__clear-icon" role="img">
                <title>Clear search</title>
                <use href="#icon-cancel"></use>
              </svg>
            </a>
          </div>

          <div class="global-search__form__filter-bar">
            <button class="filter-btn" id="tag-filter-btn">
              Tags
            </button>
            <button class="filter-btn" id="user-filter-btn">
              Held By
            </button>
            <button class="filter-btn" id="location-filter-btn">
              Location
            </button>
            <button
              class="filter-btn filter-btn--boolean filter-btn--active"
              id="checked-in-filter-btn"
            >
              Checked In
            </button>
            <button
              class="filter-btn filter-btn--boolean"
              id="checked-out-filter-btn"
            >
              Checked Out
            </button>
            <button class="filter-btn filter-btn--boolean" id="late-filter-btn">
              Out past estimated return
            </button>
            <a href="#" id="clear-filters-btn">
              Clear Filters
            </a>

            {/* <div id="tag-tooltip" class="filter-tooltip__content">
              <Select options={} />
              // <%= f.select('tags', @tags, {}, id: 'tag-select', multiple: true) %>
            </div>

            <div id="user-tooltip" class="filter-tooltip__content">
              <%= f.select(
                'users',
                @users.collect { |u| [u.display_name || u.email, u.id] },
                {},
                id: 'user-select',
                multiple: true
              ) %>
            </div>

            <div id="location-tooltip" class="filter-tooltip__content">
              <%= f.select(
                'locations',
                @locations.collect { |l| ["#{l.event.name} - #{l.name}", l.id] },
                {},
                id: 'location-select',
                multiple: true
              ) %>
            </div> */}
          </div>
        </form>
      </header>

      <section class="main-content__body main-content__body--flush global-search__results">
        <div id="welcome-screen">
          <svg role="img">
            <title>🔎w🔍</title>
            <use href="#icon-eyeglass"></use>
          </svg>
          <p>
            This page lets you search for assets by name, checked in/out state,
            current location, etc.
          </p>
        </div>

        <div id="no-results-screen">
          <h2>ʕ ಡ ﹏ ಡ ʔ</h2>
          <p>no results :&lt;</p>
        </div>

        <table id="search-results" aria-labelledby="Search Results">
          <thead>
            <tr>
              <th
                class="cell-label cell-label--tag"
                scope="col"
                role="columnheader"
                width="90"
                style="text-align: center"
              >
                Tag
              </th>

              <th
                class="cell-label cell-label--asset-name"
                scope="col"
                role="columnheader"
              >
                Asset
              </th>

              <th
                class="cell-label cell-label--user"
                scope="col"
                role="columnheader"
              >
                Currently Held By
              </th>

              <th
                class="cell-label cell-label--location"
                scope="col"
                role="columnheader"
              >
                Current Location
              </th>
            </tr>
          </thead>

          <tbody id="search-results__body"></tbody>
        </table>
      </section>
    </div>
  );
};

export default GlobalSearchIndex;

// const $results = $('#search-results__body');
// const $welcomeScreen = $('#welcome-screen');
// const $noResultsScreen = $('#no-results-screen');
//
// Table sorting & related styling
// const tableElem = document.getElementById('search-results');
// const tableSorter = tablesort(tableElem);
// tableElem.addEventListener('afterSort', () => {
//   $('.cell-label .cell-label__sort-indicator').remove();
//
//   $('.cell-label[aria-sort="ascending"]').append(`
//     <span
//       class="cell-label__sort-indicator cell-label__sort-indicator--asc"
//     >
//       <svg aria-hidden="true">
//         <use xlink:href="#icon-up-caret" />
//       </svg>
//     </span>
//   `);
//   $('.cell-label[aria-sort="descending"]').append(`
//     <span
//       class="cell-label__sort-indicator cell-label__sort-indicator--desc"
//     >
//       <svg aria-hidden="true">
//         <use xlink:href="#icon-up-caret" />
//       </svg>
//     </span>
//   `);
// });
//
// function submitSearch(formState) {
//   clearResults();
//   $.post(GLOBAL_SEARCH_URL, formState)
//     .then(results => {
//       renderPage(!!results);
//       if (results) {
//         renderResults(results);
//         tableSorter.refresh();
//       }
//     })
//     .catch(e => {
//       console.error('Error while searching:\n', e);
//       renderPage(false);
//     });
// }
//
// function renderResults(results) {
// const { assets, locations, users, tags } = results;
//
// assets.forEach(asset => {
// const user = users.find(({ id }) => id === asset.user_id);
// const location = locations.find(({ id }) => id === asset.location_id);
// const primaryTag = tags.find(({ name }) => name === asset.tag_list[0]);
//
// $results.append(`
//   <tr class="js-table-row">
//     <td
//       class="cell-data cell-data--tag"
//       data-sort="${primaryTag?.name || ''}"
//     >
//       ${
//         primaryTag
//           ? `
//             <span
//               class="asset-tag__color-dot"
//               title="${primaryTag.name}"
//               style="background-color: ${primaryTag.color}"
//             >
//               &nbsp;
//             </span>
//           `
//           : ''
//       }
//     </td>
//
//     <td class="cell-data cell-data--asset-name">
//       <a href="${ASSET_VIEW_URL(asset.id)}">
//         ${asset.name}
//       </a>
//     </td>
//
//     <td class="cell-data cell-data--user">
//       ${
//         user
//           ? `
//         <a href="${USER_VIEW_URL(user.id)}">
//           ${user.display_name || user.email}
//         </a>
//       `
//           : ''
//       }
//     </td>
//
//     <td class="cell-data cell-data--location">
//       ${
//         location
//           ? `
//         <a href="${LOCATION_VIEW_URL(location.id)}">
//           ${location.name}
//         </a>
//       `
//           : ''
//       }
//     </td>
//   </tr>
// `);
//   });
// }
