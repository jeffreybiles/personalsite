script = "<h2 class='center'>(Hi, I'm|(Greetings, my name is|Salutations, friend!  You may call me)) Jeffrey Biles</h2>"
script += "<p>I make my living through web development.  I primarily use Ruby on Rails and Ember.js because they help me create better experiences faster."
script += "<p>I'm the creator of the Ember Sparks screencast series."
script += "<p>I'm the co-host of the <a href='http://smartbookspodcast.com/'>Smart Books Podcast</a>."
script += "<p>My other interests are entrepreneurship, education, game design, and urban planning."

script.gsub!('(', '<span class="expander"><span class="expandable">')
script.gsub!('|', '</span><span class="expansion">')
script.gsub!(')', '</span></span>')

puts script