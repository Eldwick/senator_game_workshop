#Senator Game
Scraping data with nokogiri and creating a quiz with jQuery.

##Set up sandbox to practice scraping

---

    //in CMD

    mkdir nokogiri_test
    cd nokogiri_test
    bundle init
    touch scrape.rb
    subl .

    //in Gemfile
    gem "nokogiri"

    //in CMD
    bundle install

---

##Play with nokogiri

---
    //in scrape.rb
    require "nokogiri"
    require "open-uri"

    link = open("http://en.wikipedia.org/wiki/List_of_current_United_States_Senators")

    doc = Nokogiri::HTML(link)

    puts doc

---

##Find and construct data

---
    //in scrape.rb
    senator_table = doc.css("table:nth-of-type(6) tr")

    puts senator_table

    senator_table.shift

    senator_table.each do |senator_row|
        name = senator_row.css("td:nth-of-type(5) span:nth-of-type(2)").text
        state = senator_row.css("td:nth-of-type(2)").text
        image_url = senator_row.css("td:nth-of-type(4) img")[0][:src]

        senator_params = {
          name: name,
          state: state,
          image_url: image_url,
        }
        puts senator_params
    end

---

##Create Senator State Quiz rails app

___

    //in CMD
    rails new senator_state_quiz
    rails g model Senator name:string state:string image_url:string
    rake db:migrate
    rails g controller Senator game
    subl .

___

##Seed Database

---
    //in Gemfile
    gem 'nokogiri'

    //in CMD
    bundle install

    //in seeds.rb copy and paste your scraping script from scrape.rb
    ** remember to --require 'open-uri'-- ***
    ** TABLE CHANGES TO :nth-of-type(5)***
    change --puts senator_params-- to --Senator.create(senator_params)--

    //in CMD
    rake db:seed
    rails c
    Senator.all
    Senator.first
    s = _
    s.name
    s.state

---

##Set up view

---
    //in routes.rb
    root 'senator#game'

    //in CMD
    rails s

    //in browser
    localhost:3000

    //in senator_controller.rb
    def game
    @senators = Senator.all
    end

    //in game.html.erb
    <ul>
    <%= @senators.each do |senator| %>
      <li><%= senator.name  %> is from <%= senator.state  %></li>
    <% end %>
    </ul>

---

##Change view for game

---
    //in senator.rb
    **NOT BEST PRACTICE***
    def self.random
        all.shuffle.first
     end

    //in senator_controller.rb
    def game
        @senator = Senator.random
      end

    //in game.html.erb
    <div id="gameContainer">
      <h1>Guess the Senators State</h1>
      <%= image_tag(@senator.image_url) %>
      <h2><%= @senator.name %></h2>
      <%= form_tag("/", method:"get") do %>
      <input type="text" id="guess" placeholder="Guess the State">
      <input hidden name="answer" value="<%= @senator.state %>">
      <br>
      <button id="check" onclick="checkAnswer()">Check</button>
      <% end %>
      <div class="result"></div>
    </div>
    <script>
    var answer = "<%= @senator.state %>"
    </script>

---

##Create javascript to handle quiz

---
    //in senator.js.coffee
    **rename file to senator.js**
    function checkAnswer() {
      if ($("#guess").val() === answer){
        alert("Correct!")
      } else {
        alert("Nope,"+$(".name").text()+" is from " + answer)
      }
    }

---