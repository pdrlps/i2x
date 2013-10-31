require 'helper'

module Services
	
	
	##
	# = Delivery
	#
	# Main Delivery class, to be inherited by SQL, File and URL templates
	#
	class Delivery
		attr_accessor :template, :identifier, :publisher

		def initialize identifier, publisher
			@identifier = identifier
			@publisher = publisher
			@template = Template.find_by! identifier: @identifier, publisher: @publisher
			@help = Services::Helper.new
			
			self.process_helpers
		end

		
		## 
	  	# Replaces all identified variables with the matching properties in the payload
	  	#
	  	# ==== Parameters
	  	#
	  	# * +params+ - the Postman URL POST request parameters
	  	# 
	  	def process params
	  		begin
	  			@template[:payload].each_pair do |key,value|
	  				variables = @help.identify_variables @template[:payload][key]
	  				variables.each do |v|
	  					@template[:payload][key].gsub!("%{#{v}}", params[v])
	  				end
	  			end	  			
	  		rescue Exception => e
	  			puts e
	  		end
	  	end

	  	## 
	  	# Replaces all identified helpers with the matching helper functions output in the payload
	  	#
	  	def process_helpers
	  		begin
	  			@template[:payload].each_pair do |key, value|
	  				@help.replacements.each {|replacement| @template[:payload][key].gsub!(replacement[0], replacement[1])}
	  			end
	  		rescue => e
	  			puts e
	  		end
	  	end

	  	##
	  	# => Execute final delivery, to be override by inherited classes
	  	#
	  	def execute
	  	end

	end
end