jQuery ->
  $('#resume_switcher #2010').click ->
    $('#resumes').children().hide();
    $('#2010Resume').fadeIn(700);


  $('#resume_switcher #2011').click ->
    $('#resumes').children().hide();
    $('#2011Resume').fadeIn(700);


  $('#resume_switcher #2012').click ->
    $('#resumes').children().hide();
    $('#2012Resume').fadeIn(700);

  $('#resume_switcher #buzzword').click ->
    $('#resumes').children().hide();
    $('#buzzwordResume').fadeIn(700);

  $('#resumes').children().hide();
  $('#2012Resume').show();
