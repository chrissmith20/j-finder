require 'nokogiri'

class JobsController < ApplicationController

  class ScrapeItem
    def initialize(position, company, location, salary, date, description, url)
      @position = position
      @company = company
      @location = location
      @salary = salary
      @date = date
      @description = description
      @url = url
    end
    attr_reader :position
    attr_reader :company
    attr_reader :location
    attr_reader :salary
    attr_reader :date
    attr_reader :description
    attr_reader :url
  end

 def scrape_jobs
   require 'httparty'
   #pull in the page
   url = "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7"
   page_content = HTTParty.get(url)
   parsed_content = Nokogiri::HTML(page_content)

   job_listings = parsed_content.css('div.jobsearch-SerpJobCard')

   @jobs_array = []

   job_listings.each do |element|
     company = element.css('span.company').text,
     position = element.css('h2.title').text,
     location = element.css('span.accessible-contrast-color-location').text,
     salary = element.css('span.salaryText').text,
     date = element.css('span.date').text,
     description = element.css('div.summary').text,
     url = "indeed.com"

     @jobs_array << ScrapeItem.new(company, position, location, salary, date, description, url)
   end
   render template: 'scrape_jobs'
 end

  def index
    @jobs = Job.all
  end

end
