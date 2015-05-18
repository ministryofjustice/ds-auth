(function(){
  var organisationTypeSelect = $('select#organisation_organisation_type'),
      lawFirmFields = $('[data-organisation-type="law_firm,law_office"]');

  organisationTypeSelect.change(function() {
    if(this.value === 'law_firm' || this.value == 'law_office') {
      lawFirmFields.removeClass('hidden');
    } else {
      lawFirmFields.addClass('hidden');
    }
  });

  organisationTypeSelect.change();
})();
