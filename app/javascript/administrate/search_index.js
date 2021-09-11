import tablesort from 'tablesort';

const initSearchIndex = () => {
  // Enable table sorting
  tablesort(document.getElementById('search-results'));

  // Form setup
  const $searchForm = $('.global-search__form');
  const $nameQueryInput = $('.global-search__input');

  $searchForm.on('submit', e => {
    e.preventDefault();
    submitSearch();
  });

  // Search query + filters represented as JSON
  function getFormState() {
    return {
      query: $nameQueryInput.val(),
      filters: {},
    };
  }

  function saveSearch() {
    window.sessionStorage.setItem(
      'global-search-state',
      JSON.stringify(getFormState())
    );
  }

  function submitSearch() {
    saveSearch();
    $.post(`${window.location.origin}/assets/search`, getFormState())
      .then(result => console.log(result))
      .catch(e => console.error('Error while searching:\n', e));
  }
};

export default initSearchIndex;
