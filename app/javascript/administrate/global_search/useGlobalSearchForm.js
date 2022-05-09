import { useState } from 'preact/hooks';

const useGlobalSearchForm = onSubmitSearch => {
  const [query, setQuery] = useState('');
  const [filters, setFilters] = useState({
    tags: [],
    users: [],
    locations: [],
    checkedIn: false,
    checkedOut: false,
    outPastReturnTime: false,
  });

  return { query, filters };
};

export default useGlobalSearchForm;

// Query input setup
// const $searchForm = $('.global-search__form');
// const $nameQueryInput = $('.global-search__input');
// const $nameQueryClearBtn = $('.global-search__form__clear-btn');

// Filter button setup
// const $tagFilterBtn = $('#tag-filter-btn');
// const $userFilterBtn = $('#user-filter-btn');
// const $locationFilterBtn = $('#location-filter-btn');
// const $checkedInFilterBtn = $('#checked-in-filter-btn');
// const $checkedOutFilterBtn = $('#checked-out-filter-btn');
// const $lateFilterBtn = $('#late-filter-btn');

// // Filter dropdowns
// const $tagTooltip = $('#tag-tooltip');
// const $userTooltip = $('#user-tooltip');
// const $locationTooltip = $('#location-tooltip');

// Search query + filters represented as JSON
// function getFormState() {
//   formState.query = $nameQueryInput.val() || '';
//   formState.filters = {
//     /* TODO */
//   };
//
//   return formState;
// }

// function saveSearch() {
//   window.sessionStorage.setItem(
//     'global-search-state',
//     JSON.stringify(getFormState())
//   );
// }

// function restoreSearch() {
//   const saved = window.sessionStorage.getItem('global-search-state');
//   if (typeof saved === 'string') {
//     const { query /* , filters */ } = JSON.parse(saved);
//
//     $nameQueryInput.val(query);
//
//     // TODO: restore filter state

//     submitSearch();
//   }
// }

// function submitSearch() {
//   saveSearch();
//   onSubmitSearch(getFormState());
// }
