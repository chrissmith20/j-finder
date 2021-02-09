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

      @black_list = []

        job_listings.each do |element|

          raw_job_data = [
            company_data = element.css('span.company').text,
            company = { company: element.css('span.company').text },
            position = { position: element.css('h2.title').text },
            location = { location: element.css('span.accessible-contrast-color-location').text },
            salary = { salary: element.css('span.salaryText').text },
            date = { date: element.css('span.date').text },
            description = { description: element.css('div.summary').text },
            url = { url: "indeed.com" }
        ]

          bad_job_checker = raw_job_data[1][:company]

          if bad_job_checker.strip == "CyberCoders"
            @black_list << bad_job_checker
          else
            @jobs_array << ScrapeItem.new(company, position, location, salary, date, description, url)
          end

        end
binding.pry

    render template: 'scrape_jobs'
  end

end
