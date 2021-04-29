const initTagsIndex = FULL_TAG_LIST => {
  /* Tag Filter */
  const $searchInput = $('.tag-search__input');
  $searchInput.on('input', function () {
    applyFilter($(this).val());
  });

  function applyFilter(filter) {
    if (filter.trim().length === 0) {
      // Show all rows when filter cleared
      FULL_TAG_LIST.forEach(tag => $(`#asset-tag-row-${tag.id}`).show(250));
      return;
    }

    // Hide rows that don't match
    const matching = FULL_TAG_LIST.filter(tag => tag.name.indexOf(filter) > -1);
    const notMatching = FULL_TAG_LIST.filter(
      tag => tag.name.indexOf(filter) === -1
    );
    matching.forEach(tag => $(`#asset-tag-row-${tag.id}`).show(250));
    notMatching.forEach(tag => $(`#asset-tag-row-${tag.id}`).hide(250));
  }

  /* Buttons */
  $('.tag-edit-btn').on('click', onEditClick);
  $('.tag-destroy-btn').on('click', onDestroyClick);
  $('.cancel-button').on('click', onCancelClick);
  $('.save-button').on('click', onSaveClick);

  function onEditClick(e) {
    e.preventDefault();
    const tagId = $(this).data('tag-id');
    const $row = $(`#asset-tag-row-${tagId}`);
    $row.removeClass('tag-list__index__tag-row__show');
    $row.addClass('tag-list__index__tag-row__edit');
  }

  function onDestroyClick(e) {
    e.preventDefault();
    if (
      !window.confirm(
        'This will PERMANENTLY delete this tag and remove it from all assets' +
          ' currently tagged with it.\n\nReally delete?'
      )
    )
      return;

    const tagId = $(this).data('tag-id');

    $.ajax(`/admin/tags/${tagId}`, { method: 'DELETE' })
      .then(() => {
        // Hide row for deleted tag
        $(`#asset-tag-row-${tagId}`).hide(250);

        // Remove from FULL_TAG_LIST so search doesn't bring it back
        const index = FULL_TAG_LIST.findIndex(tag => tag.id === tagId);
        if (index > -1) FULL_TAG_LIST.splice(index, 1);
      })
      .catch(err =>
        console.error(`Error deleting tag with ID ${tagId}:\n`, err)
      );
  }

  function onCancelClick(e) {
    e.preventDefault();
    const tagId = $(this).data('tag-id');
    const $row = $(`#asset-tag-row-${tagId}`);
    $row.removeClass('tag-list__index__tag-row__edit');
    $row.addClass('tag-list__index__tag-row__show');
  }

  function onSaveClick(e) {
    e.preventDefault();
    const tagId = $(this).data('tag-id');
    const $row = $(`#asset-tag-row-${tagId}`);
    $row.removeClass('tag-list__index__tag-row__edit');
    $row.addClass('tag-list__index__tag-row__show');
  }

  // Prevent form submit on search box
  $('.tag-search__form').on('submit', e => e.preventDefault());
  $('.tag-search__form__clear-btn').on('click', e => {
    e.preventDefault();
    $searchInput.val('');
    $searchInput.trigger('input');
  });
};

export default initTagsIndex;
