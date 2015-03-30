require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new
products = Array.new
prices = Array.new

# Read in a page
page = agent.get("https://www.globus.cz/brno/cerpaci-stanice-a-myci-linka.html")

# Get the product names
page.search("td[@class='prices__cell prices__cell--product']").each do |product|
  products.push(product.text.gsub(" ","_"))
end

# Get the prices
page.search("td[@class='prices__cell prices__cell--price']").each do |price|
  prices.push(price.text.gsub(",","."))
end


couple = Hash[products.zip(prices)]
couple['date'] = Time.now.to_i

# Send to ScraperWiki
ScraperWiki.save_sqlite(["date"], couple)
