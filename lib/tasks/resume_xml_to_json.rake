namespace :elasticsearch do  
  task :resume_xml_to_json  => :environment do
    file_names=Dir.glob("xml_files/*")
    file_names.each do |file_name|
      puts "file name: #{file_name}"
      f = File.open(file_name)
    
      doc = Nokogiri::XML(f)
      json_file=Hash.from_xml(doc.to_xml)['Resume']
      f.close
      unless json_file['StructuredXMLResume']['ContactInfo']['PersonName']['FormattedName'].nil?
        person_name=json_file['StructuredXMLResume']['ContactInfo']['PersonName']['FormattedName']
      else
        person_name="No Name"
      end
      unless json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['Telephone'].nil?
        telephone=json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['Telephone']['FormattedNumber']
      else
        telephone="No number"
      end
      unless json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['InternetEmailAddress'].nil?
        Email=json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['InternetEmailAddress']
      else
        Email="No email"
      end

      Resume.find_or_create_by!(name: person_name, telephone: telephone, email: Email)
    end
    

  end

  
end





#bundle exec rake  elasticsearch:resume_xml_to_json

  


 
