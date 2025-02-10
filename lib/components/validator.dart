

evalEmail(value) {
  RegExp regex =  RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.length == 0) { 
    return "email is required";
  } else if (!regex.hasMatch(value)){

    return 'please enter valid email';
  }
  else{
    return null;

  }
}
evalPassword(value) {
  RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  if (value.length == 0) {
    return "password is Required";
  } else if (!regex.hasMatch(value)){
    return 'please enter 8 character alphanumeric password';
  }
    
  else{
    return null;

  }
}

             
