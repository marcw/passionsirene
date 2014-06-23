require 'twitter'
require 'RMagick'
include Magick

Twitter.configure do |config|
    config.consumer_key       = ENV['CONSUMER_KEY']
    config.consumer_secret    = ENV['CONSUMER_SECRET']
    config.oauth_token        = ENV['ACCESS_TOKEN']
    config.oauth_token_secret = ENV['ACCESS_TOKEN_SECRET']
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

pointsize = 80
canvas = Magick::Image.new(435, 225) {self.background_color = color[0]}
gc = Magick::Draw.new
gc.font = 'impact.ttf'
gc.fill = color[1]
gc.stroke = color[1]
gc.text_antialias=true
gc.pointsize(pointsize)

position = -5
chunk(original, 10).each do |row|
  gc.text(0, position += (pointsize- 15), row)
end

gc.draw(canvas)
begin
    File.delete('tst.png')
rescue
end
canvas.write('tst.png')
Twitter.update_with_media(original, File.new('tst.png'))
File.delete('tst.png')
