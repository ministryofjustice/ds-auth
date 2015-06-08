(function(){
  var profile_form = $("form.new_profile, form.edit_profile"),
  user_fields = profile_form.find("#associated-user-password-fields"),
  user_login_checkbox = profile_form.find("input.associated-user-check");

  user_login_checkbox.change(function(){
    if(this.checked){
      user_fields.show();
    } else {
      user_fields.hide();
    }
  });

  user_login_checkbox.change();

})();
