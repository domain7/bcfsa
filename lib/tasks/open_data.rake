namespace :open_data do
  desc "Load the data"
  task :load => :environment do
    require 'open-uri'
    source_urls = {
      'locations' => 'http://www.bced.gov.bc.ca/reporting/odefiles/SchoolLocations_Hist.txt' ,
      'skill_assessments' => 'http://www.bced.gov.bc.ca/reporting/odefiles/Foundation_Skills_Assessment_2012-2013.txt'
    }
    source_urls.each do |tablename,url|
      tempfile = '/tmp/import.csv'
      open(tempfile, 'w') do |file|
        file << open(url).read
      end
      `uniq #{tempfile} > #{tempfile}.tmp && mv #{tempfile}.tmp #{tempfile}`

      headers = File.open(tempfile) {|f| f.readline}
      columns = headers.downcase.gsub(/ /,'_').split("\t")
      #sql_create = %Q| CREATE TABLE #{tablename} ( \t#{columns.join(" varchar,\n\t")} varchar); |
      sql = %Q| COPY #{tablename} (#{columns.join(',')}) FROM '#{tempfile}' WITH DELIMITER E'\\t' CSV HEADER; |
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
