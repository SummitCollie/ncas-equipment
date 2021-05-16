const showFatalError = (title, text) => {
  $('.starting-message').css('display', 'none');

  const $errorContainer = $('.barcode-scanner-error');
  $errorContainer.find('.error-title').text(title);
  $errorContainer.find('.error-text').html(text);
  $errorContainer.css('display', 'block');
};

export default showFatalError;
