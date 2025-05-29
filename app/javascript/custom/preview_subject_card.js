document.addEventListener('turbo:load', function() {
  const form = document.querySelector('form#new_subject');

  if (!form) {
    return;
  }

  const nameInput = form.querySelector('#subject_name');
  const descriptionInput = form.querySelector('#subject_description');

  const previewName = document.getElementById('preview_name');
  const previewDescription = document.getElementById('preview_description');

  function updatePreview() {
    if (previewName && nameInput) {
      previewName.textContent = nameInput.value || 'Tên môn học';
    }
    if (previewDescription && descriptionInput) {
      previewDescription.textContent = descriptionInput.value || 'Mô tả môn học';
    }
  }

  updatePreview();

  if (nameInput) {
    nameInput.addEventListener('input', updatePreview);
  }

  if (descriptionInput) {
    descriptionInput.addEventListener('input', updatePreview);
  }
});

document.addEventListener('turbo:render', function() {
  const form = document.querySelector('form#new_subject');

  if (!form) {
    return;
  }

  const nameInput = form.querySelector('#subject_name');
  const descriptionInput = form.querySelector('#subject_description');

  const previewName = document.getElementById('preview_name');
  const previewDescription = document.getElementById('preview_description');

  function updatePreview() {
    if (previewName && nameInput) {
      previewName.textContent = nameInput.value || 'Tên môn học';
    }
    if (previewDescription && descriptionInput) {
      previewDescription.textContent = descriptionInput.value || 'Mô tả môn học';
    }
  }

  updatePreview();

  if (nameInput) {
    nameInput.addEventListener('input', updatePreview);
  }

  if (descriptionInput) {
    descriptionInput.addEventListener('input', updatePreview);
  }
});
