//= require sortablejs/Sortable

onload = function() {
  const el = document.getElementById('sortable-candidacies');
  const sortable = Sortable.create(el, {onEnd: function() {
    const elements = document.querySelectorAll('[data-candidacy-id]');
    var sortedCandidacyIds = [];
    elements.forEach(function(e) {
      sortedCandidacyIds.push(e.getAttribute('data-candidacy-id'))
    });
    var hiddenTag = document.getElementById('hidden-ids');
    hiddenTag.setAttribute('value', sortedCandidacyIds);
  }});
}
