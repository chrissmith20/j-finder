#======================Nokogiri Cheat Sheet===================================

# job_listings = parsed_content.css('div.jobsearch-SerpJobCard')

#----------------- Finding number of jobs---------------------------------------
    # top_results = parsed_content.css('div.resultsTop')
    #   row = top_results.css('div.secondRow')
    #     job_num = row.css('div.searchCountContainer')
    #       link = row.css('span.no-wrap a')
#================Finding URL's===============================================

# finding a specific link
# To find a link within the <div id="block2">

# nodeset = doc.xpath('//div[@id="block2"]/a/@href')

# If you know you're searching for just one link, you can use at_xpath or at_css instead:

# attr = doc.at_xpath('//div[@id="block2"]/a/@href')
# attr.value          # => "http://stackoverflow.com"
#
# element = doc.at_css('div#block2 a[href]')
# element['href']        # => "http://stackoverflow.com"

# titles = job_listings.css('h2.title')

#---------------------Will give you giant string of URL's---------------------
# urls_string = titles.xpath('//a/@href').text
# urls = parsed_content.xpath('//a/@href').text
