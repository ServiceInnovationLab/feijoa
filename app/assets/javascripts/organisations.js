
$( document ).ready(function() {
  var organisations = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/user/organisations/autocomplete?query=%QUERY',
      wildcard: '%QUERY'
    }
  });
  $('#org-query').typeahead(null, {
    displayKey: 'name',
    source: organisations
  });

  $('#org-query').bind('typeahead:select', function(ev, organisation) {
    $('#recipient_id').val(organisation.id);
    $('#org-name').text(organisation.name);
    $('#org-email').text(organisation.email);
    $('#org-address').text(organisation.address);
  });
});

