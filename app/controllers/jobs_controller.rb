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

    @jobs_array = []
      @job_url = []
      @black_list = []

    url = "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7"

    url2 = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=10"

    page_content = HTTParty.get(url)
    parsed_content = Nokogiri::HTML(page_content)

    job_listings = parsed_content.css('div.jobsearch-SerpJobCard')
    titles = job_listings.css('h2.title')
    anchor_tags = titles.css('a')

    anchor_tags.each do |object|
      everything = object.attributes.values
      job_link = everything[2].value

      @job_url << job_link
    end

    job_listings.each do |element|
      give_me_url = @job_url.shift

      raw_job_data = [
        company_data = element.css('span.company').text,
        company = { company: element.css('span.company').text },
        position = { position: element.css('h2.title').text },
        location = { location: element.css('span.accessible-contrast-color-location').text },
        salary = { salary: element.css('span.salaryText').text },
        date = { date: element.css('span.date').text },
        description = { description: element.css('div.summary').text },
        url = { url: "www.indeed.com#{give_me_url}" }
      ]

      bad_job_checker = raw_job_data[1][:company]

      if bad_job_checker.strip == "CyberCoders"
        @black_list << bad_job_checker
      else
        @jobs_array << ScrapeItem.new(company, position, location, salary, date, description, url)
      end

    end

    #============================ page 2 ===================================

    page_content2 = HTTParty.get(url2)
    parsed_content2 = Nokogiri::HTML(page_content2)
      job_listings2 = parsed_content2.css('div.jobsearch-SerpJobCard')
      titles2 = job_listings2.css('h2.title')
        anchor_tags2 = titles2.css('a')

        anchor_tags2.each do |object|
          everything = object.attributes.values
          job_link = everything[2].value

          @job_url << job_link
        end

        job_listings2.each do |element|
          give_me_url = @job_url.shift

          raw_job_data = [
            company_data = element.css('span.company').text,
            company = { company: element.css('span.company').text },
            position = { position: element.css('h2.title').text },
            location = { location: element.css('span.accessible-contrast-color-location').text },
            salary = { salary: element.css('span.salaryText').text },
            date = { date: element.css('span.date').text },
            description = { description: element.css('div.summary').text },
            url = { url: "www.indeed.com#{give_me_url}" }
          ]

          bad_job_checker = raw_job_data[1][:company]

          if bad_job_checker.strip == "CyberCoders"
            @black_list << bad_job_checker
          else
            @jobs_array << ScrapeItem.new(company, position, location, salary, date, description, url)
          end

        end
    render template: 'scrape_jobs'
  end

end
