class DiffsController < ApplicationController 
	
	def new
		@diff = Diff.new
	end
	
	def create
		@diff = current_user.diffs.build(params[:diff])
		
		if !params[:diff][:url].include? "http://" and !params[:diff][:url].empty?
			params[:diff][:url].insert(0, 'http://')
		end
		
		
		respond_to do |format|
		  if @diff.save
		  	content = Nokogiri::HTML(open(@diff.url)).to_s()
		
			scrape = Scrape.new
			scrape = @diff.scrapes.build(:content => content)
			format.html { redirect_to @diff, notice: 'User was successfully created.' }
			format.json { render json: @diff, status: :created, location: @user }
		  else
			format.html { render action: "new" }
			format.json { render json: @diff.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def show
    	@diff = Diff.find(params[:id])
    	
    	respond_to do |format|
    		format.html
    		format.json {render json: @user}
    	end
    end
	
	def index
		@diffs = Diff.where(["user_id = ?", current_user.id])
	end
	
	def sendmsg
		comments_from_form = params['myform'][:greeting]
		render comments_from_form
	end
	
# 	def show
# 		render :text => "#{params[:message]}"
#  		Resque.enqueue(Click)
# 	end
	
	
	
	def print
		require 'open-uri'
		@response = Nokogiri::HTML(open(params[:url])).to_s().html_safe
#		@div = @response.at_css("#work").content
# 		@xpath = Nokogiri::CSS.xpath_for '#work'
# 		@textbyxpath = @response.xpath(@xpath).count
		render "response"
	end
	

		
	
	
	def test
		require 'open-uri'
		
		@current_diff = Diff.find(params[:format])
		
		puts "UTILITYMSG: Starting test"
		
		@site1 = Nokogiri::HTML(open(@current_diff.url))
		
		@site1 = @site1.css(@current_diff.div).first.to_s
		
		@site2 = Scrape.find(:last, :conditions => [ "diff_id = ?", @current_diff.id])
		
		if @site2.nil?
			@site2 = @site1
		else
			@site2 = @site2.content.to_s
		end
		
		
		
		scrape = Scrape.new
		scrape = @current_diff.scrapes.build(:content => @site1)
		if scrape.save
			puts "UTILITYMSG: Scrape saved successfully"
		else
			puts "UTILITYMSG: Scrape fail"
		end
		
		@output = Diffy::Diff.new(@site2, @site1, :include_plus_and_minus_in_html => true).to_s(:html)
		render "output"
	end
	
end
