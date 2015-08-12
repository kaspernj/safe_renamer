#!/usr/bin/env ruby

class PathToRename
  FORBIDDEN_CHARACTERS = {
    '"' => '',
    '<' => '',
    '>' => '',
    '@' => ' at ',
    ':' => '-'
  }
  
  def initialize(args)
    @args = args
    @path = @args.fetch(:path)
    
    #puts "Scanning: #{@path}"
  end
  
  def scan_dir
    Dir.foreach(@path) do |file|
      next if file == '.' || file == '..'
      
      full_path = "#{@path}/#{file}"
      
      if File.directory?(full_path)
	PathToRename.new(@args.merge(path: full_path)).scan_dir
      else
	FORBIDDEN_CHARACTERS.each do |key, value|
	  next unless file.include?(key)
	  
	  puts "Found illegal instance of '#{key}' in '#{full_path}'"
	  
	  new_file = file.gsub(key, value)
	  new_path = "#{@path}/#{new_file}"
	  
	  puts "Moving to: #{new_path}"
	  
	  File.rename(full_path, new_path)
	  full_path = new_path
	end
      end
    end
  end
end

path = ARGV[0]

puts "Path: #{path}"

begin
  PathToRename.new(path: path).scan_dir
rescue => e
  puts e.inspect
  puts e.backtrace.slice(0, 25)
end
