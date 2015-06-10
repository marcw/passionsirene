require 'twitter'
require 'RMagick'
require 'unirest'
include Magick

client = Twitter::REST::Client.new do |config|
    config.consumer_key       = ENV['CONSUMER_KEY']
    config.consumer_secret    = ENV['CONSUMER_SECRET']
    config.access_token        = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end


r = Random.new

original = "A" * r.rand(1..15)
original += "H" * r.rand(4..15)
if r.rand(0..60) == 10
    original += "hipse"
end
original += "U" * r.rand(10..35)


def word_wrap(text, columns = 80)
  text.split("\n").collect do |line|
    line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
  end * "\n"
end

def chunk(string, size)
    string.scan(/.{1,#{size}}/)
end

colors = [
    ["#fffd2f", "#000000"],
    ["#0036ff", "#ffffff"],
    ["#00ff32", "#ffffff"],
    ["#f800ef", "#ffffff"],
    ["#000000", "#ffffff"],
]

color = colors.sample

coef = 6
pointsize = 80 * coef
canvas = Magick::Image.new(435 * coef, 225 * coef) {self.background_color = color[0]}
gc = Magick::Draw.new
gc.font = 'impact.ttf'
gc.fill = color[1]
gc.stroke = color[1]
gc.text_antialias=true
gc.pointsize(pointsize)

position = -5 * coef
chunk(original, 10).each do |row|
  gc.text(0, position += (pointsize- 15 * coef), row)
end

gc.draw(canvas)
begin
    File.delete('tst.png')
rescue
end
canvas.write('tst.png')

bg_color = "White"

time = Time.new
product_name = sprintf "AHU %d/%d/%d", time.day, time.month, time.year

rapanui_api_key = ENV['RAPANUI_API_KEY']
Unirest.timeout(20)
response = Unirest.post "https://rapanuistore.com/api-access-point/",
                        parameters: { :api_key => rapanui_api_key, 
                                      :file => File.new('tst.png', 'r'),
                                      :product_name => product_name,
                                      :colour => bg_color,
                                      :product_url_prefix => 'ahu' }

if response.code == 200
    link = response.body
    original = original + " " + link
end

media_id = client.upload(File.new('tst.png'))
client.update(original, { :media_ids => media_id })
File.delete('tst.png')
