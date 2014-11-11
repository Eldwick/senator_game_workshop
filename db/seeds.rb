# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "open-uri"

link = open("http://en.wikipedia.org/wiki/List_of_current_United_States_Senators")

doc = Nokogiri::HTML(link)

senator_table = doc.css("table:nth-of-type(5) tr")

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
    Senator.create(senator_params)
end