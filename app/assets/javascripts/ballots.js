//= require sortablejs/Sortable

onload = function() {
  const el = document.getElementById('sortable-candidacies');
  const sortable = Sortable.create(el, {onEnd: function() {
    const elements = document.querySelectorAll('[data-candidacy-id]');
    let sorted_candidacy_ids = [];
    elements.forEach(function(e) {
      sorted_candidacy_ids.push(e.getAttribute('data-candidacy-id'))
    });
    let hidden_tag = document.getElementById('hidden-ids');
    hidden_tag.setAttribute('value', sorted_candidacy_ids);
  }});
}
