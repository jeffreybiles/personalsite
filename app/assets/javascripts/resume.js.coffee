jQuery ->
  $('#resume_switcher #serious').click ->
    $('#resumes').children().hide();
    $('#serious_resume').fadeIn(700);


  $('#resume_switcher #exciting').click ->
    $('#resumes').children().hide();
    $('#exciting_resume').fadeIn(700);


  $('#resume_switcher #buzzword').click ->
    $('#resumes').children().hide();
    $('#buzzword_resume').fadeIn(700);

  $('#resumes').children().hide();
  $('#buzzword_resume').show();
