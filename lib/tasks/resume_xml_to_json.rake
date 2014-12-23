namespace :elasticsearch do  
  task :resume_xml_to_json  => :environment do
    file_names=Dir.glob("xml_files/*")
    count=0
    file_names.each do |file_name|
      count+=1
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
        begin
          telephone=json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['Telephone']['FormattedNumber']
        rescue
          telephone=json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['Telephone'][0]['FormattedNumber']
        end
        
      else
        telephone="No Number"
      end
      unless json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['InternetEmailAddress'].nil?
        Email=json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['InternetEmailAddress']
      else
        Email="No Email"
      end
      Country="Country"+count.to_s
      

      resume=Resume.find_or_create_by!(name: person_name, telephone: telephone, email: Email, country: Country)
      
      unless json_file['StructuredXMLResume']['Competency'].nil?
        competencies=json_file['StructuredXMLResume']['Competency']
          unless competencies.nil?
            competencies.each do |competency|
              unless competency.nil?
                competency_description=nil
                competency_name=nil
                skill_level=nil
                skill_proficiency=nil
                competency_description=competency['description'] unless  competency['description'].nil?
                 competency_name=competency['name'] unless competency['name'].nil?
                 
                 unless competency['CompetencyWeight'].nil?
                   competency_weights=competency['CompetencyWeight']
                   
                   competency_weights.each do |competency_weight|
                     if competency_weight.kind_of? Array
                       if competency_weight[0] == "NumericValue"
                         skill_level=competency_weight[1].to_i
                       elsif competency_weight[0] == "StringValue"
                         skill_proficiency=competency_weight[1]
                       end
                     elsif competency_weight.kind_of? Hash
                       if competency_weight['type']=="skillLevel"
                        skill_level=competency_weight['NumericValue'].to_i
                      elsif competency_weight['type']=="skillProficiency"
                        skill_proficiency=competency_weight['StringValue']
                      end
                     end
                   end
                 end
                 
                 resume.competencies.find_or_create_by!(name: competency_name, description: competency_description, 
                   skill_level: skill_level,skill_proficiency: skill_proficiency )
              end
          end
        end
      end
      
    end
    Resume.__elasticsearch__.create_index! force: true
    Resume.import

  end

  
end




#Resume.__elasticsearch__.create_index! force: true
#bundle exec rake  elasticsearch:resume_xml_to_json

  


 
