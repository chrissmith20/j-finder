require 'nokogiri'

class JobsController < ApplicationController

  class ScrapeItem
    def initialize(company, position, location, salary, date, description, url)
      @company = company
      @position = position
      @location = location
      @salary = salary
      @date = date
      @description = description
      @url = url
    end
    attr_reader :company
    attr_reader :position
    attr_reader :location
    attr_reader :salary
    attr_reader :date
    attr_reader :description
    attr_reader :url
  end

  def scrape_jobs
   require 'httparty'

   # url = "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7"
   # second_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=10"
   # third_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=20"
   # fourth_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=30"

    data_hash = {

      first_page: "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7",

      second_page: "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=10",

    }

    @jobs_array = []
    @job_url = []
    @black_list = []
    anchor_tag_array = []

    data_hash.each do |key, value|
      page_data = HTTParty.get(value)
      parsed_data = Nokogiri::HTML(page_data)
      @job_listings_data = parsed_data.css('div.jobsearch-SerpJobCard')
      anchor_tag_array << @job_listings_data
      # single_anchor_tag = anchor_tags.attributes.values
      # anchor_tag_array << anchor_tags
    end

    # title_data = @job_listings_data.css('h2.title')
    #
    binding.pry
    # anchor_tag_array << title_data.css('a').attributes
#=============================================================================

    anchor_tag_array.each do |element, item|
      # element = first url
      # item = second url

      # give_me_url = @job_url.shift

        binding.pry
        company_data = element.css('span.company').text,
        company = { company: element.css('span.company').text },
        position = { position: element.css('h2.title').text },
        location = { location: element.css('span.accessible-contrast-color- location').text },
        salary = { salary: element.css('span.salaryText').text },
        date = { date: element.css('span.date').text },
        description = { description: element.css('div.summary').text },
        url = { url: "www.indeed.com" }


      bad_job_checker = [:company]

      if bad_job_checker.strip == "CyberCoders"
        @black_list << bad_job_checker
      else
        @jobs_array << ScrapeItem.new(company, position, location, salary, date,  description, url)
      end
    end

#============================= Without a Hash ================================
    render template: 'scrape_jobs'
  end

end
