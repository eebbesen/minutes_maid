function toggleSignUpEnabled() {
  elements = document.getElementsByName('commit');
  if (elements.length > 0) {
    elements[0].toggleAttribute('disabled');
  } else {
    console.log('ERROR: could not find button with name "commit"');
  }
}
