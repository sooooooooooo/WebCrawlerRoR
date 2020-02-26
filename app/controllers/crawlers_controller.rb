require "pstore"

class CrawlersController < ApplicationController
	@@store_jobs = PStore.new("data.pstore")

  def index
  	puts "@@store_jobs is nil? #{@@store_jobs.nil?}"
  	puts ""
  	if !@@store_jobs.nil?
  		@jobs = @@store_jobs.transaction { @@store_jobs[:jobs] }
  		# puts "got here, #{@jobs}"
  	end
  end

  def create
  	search_term = search_params[:search_term]
		city = search_params[:city]
		state = search_params[:state]
		q_search_term = search_term.downcase.split(" ").join("+")
		if city.include? " "
			q_city = city.split.map(&:capitalize).join("+")
		else
			q_city = city.downcase.capitalize
		end
		q_state = state.upcase
		q_url = search_params[:url]
		
		url = q_url+"jobs?q="+q_search_term+"&l="+q_city+"%2C+"+q_state
		unparsed_page = HTTParty.get(url)
		parsed_page = Nokogiri::HTML(unparsed_page)

		# @@store_jobs = PStore.new("data.pstore")
		@@store_jobs.transaction do
			@@store_jobs[:jobs] = []
		end
		job_listings = parsed_page.css("div.jobsearch-SerpJobCard") #19 jobs

		page = 1
		per_page = job_listings.count #19
		total = parsed_page.css("div#searchCountPages").text.split(" ")[3].gsub(",","").to_i #3164
		last_page = (total.to_f / per_page.to_f).round

		next_link = parsed_page.css("span.np").text

		while next_link.include? "Next"
			if page == 1
				pagination_url = q_url+"jobs?q="+q_search_term+"&l="+q_city+"%2C+"+q_state
			else
				pagination_url = q_url+"jobs?q="+q_search_term+"&l="+q_city+"%2C+"+q_state+"&start="+((page-1)*10).to_s
			end
			puts "Have next_link: #{next_link.include? "Next"}"
			puts "Digging #{pagination_url}"
			puts "Page: #{page}"
			puts ""
			pagination_unparsed_page = HTTParty.get(pagination_url)
			pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
			pagination_job_listings = pagination_parsed_page.css("div.jobsearch-SerpJobCard")

			pagination_job_listings.each do |jl|
				job = {
					title: jl.css("div.title").text.tr("\n",""),
					company: jl.css("span.company").text.tr("\n",""),
					location: jl.css(".location").text,
					url: "https://www.indeed.com"+jl.css("a")[0].attributes["href"].value
				}
				# jobs << job
				@@store_jobs.transaction do
					@@store_jobs[:jobs] << job
				end
				puts "Scooped #{job[:title]}"
				puts ""
			end

			# per_page = pagination_job_listings.count
			# last_page = (total.to_f / per_page.to_f).round

			# puts "Per page is now #{per_page}"
			# puts "Last page is now #{last_page}"
			# puts ""

			next_link = pagination_parsed_page.css("span.np").text #while loop doesn't stop!!!

			page += 1
		end

		pagination_url = q_url+"jobs?q="+q_search_term+"&l="+q_city+"%2C+"+q_state+"&start="+((page-1)*10).to_s
		pagination_unparsed_page = HTTParty.get(pagination_url)
		pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
		pagination_job_listings = pagination_parsed_page.css("div.jobsearch-SerpJobCard")

		puts "Have next_link: #{next_link.include? "Next"}"
		puts "Digging #{pagination_url}"
		puts "Page: #{page}"
		puts ""

		pagination_job_listings.each do |jl|
			job = {
				title: jl.css("div.title").text.tr("\n",""),
				company: jl.css("span.company").text.tr("\n",""),
				location: jl.css(".location").text,
				url: "https://www.indeed.com"+jl.css("a")[0].attributes["href"].value
			}
			# jobs << job
			@@store_jobs.transaction do
				@@store_jobs[:jobs] << job
			end
			puts "Scooped #{job[:title]}"
			puts ""
		end

		puts "@@store_jobs is nil? #{@@store_jobs.nil?}"
		# puts "@@store_jobs is: #{@@store_jobs.transaction { @@store_jobs[:jobs] }}"
		puts ""

		redirect_to "/crawlers"

  end

  def destroy
  	@@store_jobs.transaction do
			@@store_jobs[:jobs] = []
		end
		redirect_to "/crawlers"
  end

  def contact
  	
  end

  private
  	def search_params
  		params.require(:search).permit(:search_term, :city, :state, :url)
  	end
end
