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
    this.$cancelBtn = this.$screen.find('.cancel-btn');
    this.$actionBtn = this.$screen.find('.action-btn');

    this.eventHandler.on('got-asset-data', data => {
      this.populateContent(data);
      this.show();
    });

    this.$cancelBtn.on('click', () => {
      this.eventHandler.emit('resume-scanning');
      this.hide();
    });
    this.$actionBtn.on('click', () => {
      this.eventHandler.emit('resume-scanning');
      this.hide();
    });
  }

  populateContent(data) {
    this.$title.empty();
    this.$content.empty();

    this.$title.text(data.name);

    const props = {
      id: 'ID',
      name: 'Name',
      tags: 'Tags',
      description: 'Description',
      user: 'User',
      location: 'Location',
    };

    Object.keys(props).forEach(prop => {
      if (prop === 'tags') {
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
            <div class="asset-prop__name">${props[prop]}</div>
            <div class="asset-prop__value">${
              typeof data[prop] !== 'undefined' && data[prop] !== null
                ? data[prop]
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
