jQuery ->
  $('#resume_switcher #ten').click ->
    $('#resumes').children().hide();
    $('#ten').fadeIn(700);


  $('#resume_switcher #eleven').click ->
    $('#resumes').children().hide();
    $('#eleven').fadeIn(700);


  $('#resume_switcher #twelve').click ->
    $('#resumes').children().hide();
    $('#twelve').fadeIn(700);

  $('#resume_switcher #buzzword').click ->
    $('#resumes').children().hide();
    $('#buzzword_resume').fadeIn(700);

  $('#resumes').children().hide();
  $('#twelve').show();
