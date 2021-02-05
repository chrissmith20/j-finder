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
   url = "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7"
   page_content = HTTParty.get(url)
   parsed_content = Nokogiri::HTML(page_content)

    job_listings = parsed_content.css('div.jobsearch-SerpJobCard')
      company_info = job_listings.css('div.sjcl')



    @jobs_array = []

    job_listings.each do |element|
        company = element.css('span.company').text,
        position = element.css('h2.title').text,
        location = element.css('span.accessible-contrast-color-location').text,
        salary = element.css('span.salaryText').text,
        date = element.css('span.date').text,
        description = element.css('div.summary').text,
        url = "indeed.com"


        @jobs_array << ScrapeItem.new(
          company,
          position,
          location,
          salary,
          date,
          description,
          url
        )


    end

    # @new_job = []

    # @new_job <<

    @jobs_array[0].company[0]
    # binding.pry

    render template: 'scrape_jobs'
  end



  # new_job = {
  #   "comp_key" => [],
  #   "position_key" => [],
  #   "location_key" => [],
  #   "salary_key" => [],
  #   "date_key" => [],
  #   "description_key" => [],
  #   "url_key" => []
  # }
  # black_list = ["CyberCoders, Revature"]
  # ScrapeItem.new(
  #   company,
  #   position,
  #   location,
  #   salary,
  #   date,
  #   description,
  #   url
  # )
  #
  # binding.pry
  #
  #
  # black_list.each do |bad_job|
  #   if bad_job === ScrapeItem["comp_key"].values
  #     ScrapeItem.delete(new_job)
  #   elsif
  #     @jobs_array << ScrapeItem
  #   end
  # end

end
