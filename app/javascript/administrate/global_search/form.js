import tippy from 'tippy.js';
import 'tippy.js/dist/tippy.css';
import 'tippy.js/themes/light.css';
import 'tippy.js/animations/shift-toward.css';

const formState = {
  query: '',
  filters: {},
};

function initGlobalSearchForm(onSubmitSearch) {
  // Query input setup
  const $searchForm = $('.global-search__form');
  const $nameQueryInput = $('.global-search__input');
  const $nameQueryClearBtn = $('.global-search__form__clear-btn');

  // Filter button setup
  const $tagFilterBtn = $('#tag-filter-btn');
  const $userFilterBtn = $('#user-filter-btn');
  const $locationFilterBtn = $('#location-filter-btn');
  const $checkedInFilterBtn = $('#checked-in-filter-btn');
  const $checkedOutFilterBtn = $('#checked-out-filter-btn');
  const $lateFilterBtn = $('#late-filter-btn');

  // Filter dropdowns
  const $tagTooltip = $('#tag-tooltip');
  const $userTooltip = $('#user-tooltip');
  const $locationTooltip = $('#location-tooltip');

  $nameQueryClearBtn.on('click', e => {
    e.preventDefault();
    $nameQueryInput.val('');
    submitSearch();
  });

  $searchForm.on('submit', e => {
    e.preventDefault();
    submitSearch();
  });

  const tippyOptions = {
    allowHTML: true,
    trigger: 'click',
    placement: 'bottom',
    interactive: true,
    animation: 'shift-toward',
    theme: 'light',
    appendTo: document.body,
  };

  tippy($tagFilterBtn[0], {
    content: $tagTooltip.html(),
    ...tippyOptions,
  });
  tippy($userFilterBtn[0], {
    content: $userTooltip.html(),
    ...tippyOptions,
  });
  tippy($locationFilterBtn[0], {
    content: $locationTooltip.html(),
    ...tippyOptions,
  });

  // TODO - selectize dropdowns

  // Restore any previous search from current session
  restoreSearch();

  // Search query + filters represented as JSON
  function getFormState() {
    formState.query = $nameQueryInput.val() || '';
    formState.filters = {
      /* TODO */
    };

    return formState;
  }

  function saveSearch() {
    window.sessionStorage.setItem(
      'global-search-state',
      JSON.stringify(getFormState())
    );
  }

  function restoreSearch() {
    const saved = window.sessionStorage.getItem('global-search-state');
    if (typeof saved === 'string') {
      const { query /* , filters */ } = JSON.parse(saved);

      $nameQueryInput.val(query);

      // TODO: restore filter state

      submitSearch();
    }
  }

  function submitSearch() {
    saveSearch();
    onSubmitSearch(getFormState());
  }

  return { getFormState };
}

export default initGlobalSearchForm;
