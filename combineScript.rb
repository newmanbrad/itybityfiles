# Combine- Minify CSS and JS Files
# By: Brad Newman 03/13
# Requires yuicompressor-2.4.7.jar

# Requirements
require 'net/http'
require 'fileutils'
require 'rexml/document'

#Globals
cssGlobalFileName = "combinedCSS"
jsGlobalFileName = "combinedJS"
globalProcess = "none"

#Set xml file that contains file list
file = File.new("fileList.xml")
doc = REXML::Document.new file

#For storing output
cssContentStore = []
jsContentStore = []

#Get Global Selection from XML
doc.elements.each("main/") { |element| 
	cssGlobalFileName = element.attributes["cssfilename"]
	jsGlobalFileName = element.attributes["jsfilename"]
	globalProcess = element.attributes["type"]
}

#Loop CSS
doc.elements.each("main/css/file"){ |element| 
	baseFilename = File.basename(element.text,".css") 
	currentDirectory = File.dirname(element.text)
	if globalProcess == "none"
		puts "Minfy CSS"
		compressionCommand = "java -jar yuicompressor-2.4.7.jar #{element.text}  -o #{currentDirectory}\\#{baseFilename}-min.css"
		puts "converting #{baseFilename}..."
		IO.popen(compressionCommand,"w+") do |pipe|
			pipe.puts "executing..."
			pipe.close_write
			pipe.read
		end
		puts "done with #{baseFilename} moving on..." 
		puts #return
	else 	
		puts "Combine/Minify CSS"
		compressionCommand = "java -jar yuicompressor-2.4.7.jar #{element.text}  #{currentDirectory}\\#{baseFilename}-min.css"
		fileoutput = IO.popen(compressionCommand,"w+") do |pipe|
			pipe.puts "executing..."
			pipe.close_write
			pipe.read
		end
		#Add Contents To Array
		cssContentStore << fileoutput
	end
}

#If Necessary to write file - than do it!
if cssContentStore.any? 
	# global CSS File Creation
	entry = File.new("#{cssGlobalFileName}.css","w")
	entry.puts cssContentStore
end

#Loop JS
doc.elements.each("main/js/file"){ |element| 
	baseFilename = File.basename(element.text,".js") 
	currentDirectory = File.dirname(element.text)
	if globalProcess == "none"
		puts "Minfy Scripts"
		compressionCommand = "java -jar yuicompressor-2.4.7.jar #{element.text}  -o #{currentDirectory}\\#{baseFilename}-min.js"
		puts "converting #{baseFilename}..."
		IO.popen(compressionCommand,"w+") do |pipe|
			pipe.puts "executing..."
			pipe.close_write
			pipe.read
		end
		puts "done with #{baseFilename} moving on..." 
		puts #return
	else
		puts "Combine/Minify JS"
		compressionCommand = "java -jar yuicompressor-2.4.7.jar #{element.text}  #{currentDirectory}\\#{baseFilename}-min.js"
		fileoutput = IO.popen(compressionCommand,"w+") do |pipe|
			pipe.puts "executing..."
			pipe.close_write
			pipe.read
		end
		#Add Contents To Array
		jsContentStore << fileoutput
	end
}

#If Necessary to write file - than do it!
if jsContentStore.any? 
	# global CSS File Creation
	entry = File.new("#{jsGlobalFileName}.js","w")
	entry.puts jsContentStore
end