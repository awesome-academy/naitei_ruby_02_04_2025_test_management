$(document).on('turbo:load turbo:render', function() {
  const $form = $('form.new_subject, form.edit_subject');

  if (!$form.length) {
    return;
  }

  const $nameInput = $form.find('#subject_name');
  const $descriptionInput = $form.find('#subject_description');
  const $previewName = $('#preview_name');
  const $previewDescription = $('#preview_description');

  function updatePreview() {
    if ($previewName.length && $nameInput.length) {
      $previewName.text($nameInput.val() || 'Tên môn học');
    }
    if ($previewDescription.length && $descriptionInput.length) {
      $previewDescription.text($descriptionInput.val() || 'Mô tả môn học');
    }
  }

  updatePreview();

  if ($nameInput.length) {
    $nameInput.on('input', updatePreview);
  }

  if ($descriptionInput.length) {
    $descriptionInput.on('input', updatePreview);
  }
});
