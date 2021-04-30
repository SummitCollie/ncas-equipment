import Pickr from '@simonwep/pickr';

import '@simonwep/pickr/dist/themes/nano.min.css';

const initTagsIndex = FULL_TAG_LIST => {
  // Edited tag states
  // { tagId: { color, name } }
  const TagStates = {};
  const setTagState = (tagId, data) => {
    if (!data) return delete TagStates[tagId];
    if (!TagStates[tagId]) {
      const defaults = FULL_TAG_LIST.find(t => t.id === tagId);
      TagStates[tagId] = { name: defaults.name, color: defaults.color };
    }
    TagStates[tagId] = { ...TagStates[tagId], ...data };
  };

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
    toggleEditMode(tagId, true);
  }

  function onDestroyClick(e) {
    e.preventDefault();
    if (
      !window.confirm(
        'This will PERMANENTLY delete this tag and remove it from all assets' +
          ' currently tagged with it.\n\nReally delete?'
      )
    ) {
      return;
    }

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

  function toggleEditMode(tagId, bool) {
    const $row = $(`#asset-tag-row-${tagId}`);
    if (bool) {
      $row.removeClass('tag-list__index__tag-row__show');
      $row.addClass('tag-list__index__tag-row__edit');
    } else {
      $row.removeClass('tag-list__index__tag-row__edit');
      $row.addClass('tag-list__index__tag-row__show');
    }
  }

  function onCancelClick(e) {
    e.preventDefault();
    const tagId = $(this).data('tag-id');
    toggleEditMode(tagId, false);
  }

  function onSaveClick(e) {
    e.preventDefault();
    const tagId = $(this).data('tag-id');
    toggleEditMode(tagId, false);

    if (TagStates[tagId]) {
      $.ajax(`/admin/tags/${tagId}`, {
        method: 'PATCH',
        data: { tag: TagStates[tagId] },
      })
        .then(() => {
          // Update show-view in-place with new values
          const $row = $(`#asset-tag-row-${tagId} .tag-row__show-view`);
          $row.find('.asset-tag__text').text(TagStates[tagId].name);
          $row
            .find('.asset-tag__color-dot')
            .css('background-color', TagStates[tagId].color);
        })
        .catch(err =>
          console.error(`Error updating tag with ID ${tagId}:\n`, err)
        );
    }
  }

  // Prevent form submit on search box
  $('.tag-search__form').on('submit', e => e.preventDefault());
  $('.tag-search__form__clear-btn').on('click', e => {
    e.preventDefault();
    $searchInput.val('');
    $searchInput.trigger('input');
  });

  /* Color pickers init */
  FULL_TAG_LIST.forEach(tag => {
    const toggleElem = $(`#color-edit-toggle-${tag.id}`)[0];
    const pickr = Pickr.create({
      el: toggleElem,
      theme: 'nano',
      useAsButton: true,
      lockOpacity: true,
      default: tag.color,
      components: {
        preview: true,
        hue: true,
        interaction: {
          input: true,
          save: true,
        },
      },
    });

    pickr.on('save', hsva => {
      const chosenColor = `#${hsva.toHEXA().join('')}`;
      setTagState(tag.id, { color: chosenColor });
      const $dot = $(
        `#asset-tag-row-${tag.id} .tag-row__edit-view .asset-tag__color-dot`
      );
      $dot.css('background-color', chosenColor);
      pickr.hide();
    });
  });

  /* Name input init */
  const $nameInputs = $('.tag-name-input');
  $nameInputs.each(function () {
    const $input = $(this);
    $input.on('input', () => {
      setTagState($input.data('tag-id'), { name: $input.val() });
    });
  });
};

export default initTagsIndex;
