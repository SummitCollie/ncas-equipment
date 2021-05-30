/**
 * Class to manage the screen that pops up with asset details and
 * actions after scanning a barcode.
 */
class ActionScreen {
  constructor(eventHandler) {
    this.eventHandler = eventHandler;
    this.$screen = $('.barcode-action-screen');
    this.$title = this.$screen.find('.barcode-action-screen__title');
    this.$content = this.$screen.find('.barcode-action-screen__details');

    this.eventHandler.on('got-asset-data', data => {
      this.populateContent(data);
      this.show();
    });
  }

  populateContent(data) {
    this.$title.empty();
    this.$content.empty();

    this.$title.text(data.name);

    const props = ['id', 'description', 'tags', 'user', 'location'];
    props.forEach(propName => {
      if (propName === 'tags') {
        this.$content.append('<div class="asset-prop__name">Tags</div>');
        this.$content.append(() => {
          const content = ['<div class="asset-prop__tags">'];
          data.tags.forEach(tag =>
            content.push(
              `
              <span class="asset-tag">
                <span class="asset-tag__color-dot" style="background-color: ${tag.color}">
                  &nbsp;
                </span>
                <span class="asset-tag__text">
                  ${tag.name}
                </span>
              </span>
              `.replace(/\s\s*$/gm, '')
            )
          );
          content.push('</div>');

          return content.join('');
        });
      } else {
        this.$content.append(
          `
            <div class="asset-prop__name">${propName}</div>
            <div class="asset-prop__value">${
              typeof data[propName] !== 'undefined' && data[propName] !== null
                ? data[propName]
                : ''
            }</div>
          `.replace(/\s\s*$/gm, '')
        );
      }
    });
  }

  show() {
    this.$screen.addClass('barcode-action-screen--visible');
  }

  hide() {
    this.$screen.removeClass('barcode-action-screen--visible');
  }
}

export default ActionScreen;
