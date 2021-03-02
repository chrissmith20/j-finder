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
   # second_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=10"
   # third_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=20"
   # fourth_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=30"

    data_hash = {
      first_page: "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7s",
      second_page: "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=10",
      third_page: "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=20",
      fourth_page: "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=30",
    }

    @job_url = []
    @black_list = []
    anchor_tag_array = []

    data_hash.each do |key, value|
      page_data = HTTParty.get(value)
      parsed_data = Nokogiri::HTML(page_data)
      @job_listings_data = parsed_data.css('div.jobsearch-SerpJobCard')

      title_data = @job_listings_data.css('h2.title')
      anchor_tags = title_data.css('a')

      single_anchor_tag = anchor_tags.attributes.values
      binding.pry
      anchor_tag_array << anchor_tags
    end

    anchor_tag_array.each do |object|
      everything = object.attributes.values
      job_link = everything[2].value


      @job_url << job_link
    end

#=============================================================================

    @job_listings_data.each do |element|
      give_me_url = @job_url.shift

      raw_job_data = [
        company_data = element.css('span.company').text,
        company = { company: element.css('span.company').text },
        position = { position: element.css('h2.title').text },
        location = { location: element.css('span.accessible-contrast-color- location').text },
        salary = { salary: element.css('span.salaryText').text },
        date = { date: element.css('span.date').text },
        description = { description: element.css('div.summary').text },
        url = { url: "www.indeed.com#{give_me_url}" }
      ]

      bad_job_checker = raw_job_data[1][:company]

      if bad_job_checker.strip == "CyberCoders"
        @black_list << bad_job_checker
      else
        @jobs_array << ScrapeItem.new(company, position, location, salary, date,  description, url)
      end
    end
    
#============================= Without a Hash ================================
    data = []

    url_array = []

    url_array << url
    url_array << second_page_urls
    # @url_array << third_page_urls
    # @url_array << fourth_page_urls

    url_array.each do |x|
      page_content = HTTParty.get(x)
      parsed_content = Nokogiri::HTML(page_content)
      data << parsed_content
    end

    job_listings = data[0].css('div.jobsearch-SerpJobCard')
      titles = job_listings.css('h2.title')
        anchor_tag_array = titles.css('a')

        binding.pry

      @jobs_array = []
#================== Links/URL's ============================================
        # anchor_tag_array.each do |object|
        #   everything = object.attributes.values
        #   job_link = everything[2].value
        #
        #   @job_url << job_link
        # end
#============================Landing Page jobs=================================

  job_listings.each do |element|
    give_me_url = @job_url.shift

    raw_job_data = [
      company_data = element.css('span.company').text,
      company = { company: element.css('span.company').text },
      position = { position: element.css('h2.title').text },
      location = { location: element.css('span.accessible-contrast-color- location').text },
      salary = { salary: element.css('span.salaryText').text },
      date = { date: element.css('span.date').text },
      description = { description: element.css('div.summary').text },
      url = { url: "www.indeed.com#{give_me_url}" }
    ]

    bad_job_checker = raw_job_data[1][:company]

    if bad_job_checker.strip == "CyberCoders"
      @black_list << bad_job_checker
    else
      @jobs_array << ScrapeItem.new(company, position, location, salary, date,  description, url)
    end
  end

  #==============================Pagination==================================

    page = 0
    last_page = 30

    while page <= last_page do

      pagination_url = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=10"
      pagination_page_content = HTTParty.get(pagination_url)
      pagination_parsed_content = Nokogiri::HTML(pagination_page_content)
        pagination_job_listings = pagination_parsed_content.css('div.jobsearch-SerpJobCard')

        second_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=20"


        third_page_urls = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&sort=date&start=30"
        pagination_page_content = HTTParty.get(third_page_urls)


        pagination_job_listings.each do |element|
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
      page += 10
    end
    #=========================Pagination Links===============================


    render template: 'scrape_jobs'
  end

end
