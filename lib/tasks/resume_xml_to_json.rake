namespace :elasticsearch do  
  task :resume_xml_to_json  => :environment do
    file_names=Dir.glob("xml_files/*")
    file_names.each do |file_name|
      puts "file name: #{file_name}"
      f = File.open(file_name)
    
      doc = Nokogiri::XML(f)
      json_file=Hash.from_xml(doc.to_xml)['Resume']
      f.close
      
      val = json_file['StructuredXMLResume']['ContactInfo']['PersonName']['FormattedName']
      unless val.nil?
        person_name=val
      else
        person_name="notAvailable"
      end
      puts "person_name: #{person_name}"
      
      val = json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['Telephone']
      unless val.nil?
        if val.kind_of? Array
          telephone="#{val[0]['FormattedNumber']}"
        else
          telephone="#{val['FormattedNumber']}"
        end
        
      else
        telephone="No number"
      end
      puts "telephone: #{telephone}"
      
      val = json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['InternetEmailAddress']
      unless val.nil?
        if val.kind_of? Array
          email = val.first
        else
          email = val
        end
      else
        email="No email"
      end
      puts "email: #{email}"
      
      val = json_file['StructuredXMLResume']['ContactInfo']['ContactMethod']['PostalAddress']
      unless val.nil?
        if val.kind_of? Array
          country_code = val[0]['CountryCode']
        else
          country_code = val['CountryCode']
        end
      else
        country_code = "notAvailable"
      end
      
      val = json_file['StructuredXMLResume']['ExecutiveSummary']
      unless val.nil?
        summary = val
      end
      
      org = json_file['StructuredXMLResume']['EmploymentHistory']
      
      unless org.nil?
        val = org['EmployerOrg']
        if val.kind_of? Array
          val2 = val[0]['EmployerOrgName']
          val3 = val[0]['EmployerContactInfo']
          val4 = val[0]['PositionHistory']
        else
          val2 = val['EmployerOrgName']
          val3 = val['EmployerContactInfo']
          val4 = val['PositionHistory']
        end
        
        org_name = val2 || "notAvailable"

        unless val3.nil?
          org_country_code = val3['CountryCode'] || "notAvailable"
        else
          org_country_code = "notAvailable"
        end

        unless val4.nil?
          title = val4['Title'] || "notAvailable"
          org_summary = val4['Description'] || "notAvailable"
          start_date = val4['StartDate']['YearMonth'] || "notAvailable"
          end_date = val4['EndDate']['YearMonth'] || "notAvailable"
          months_of_work = val4['UserArea']['DaxPositionHistoryUserArea']['MonthsOfWork'] || "notAvailable"
        end
      end

      resume = Resume.find_or_create_by!(name: person_name, telephone: telephone, email: email, country: country_code)
      resume.create_note(summary: summary)
      
      unless org.nil?
        emp_history = resume.employer_histories.find_or_create_by!(organization_name: org_name, title: title, country_code: org_country_code, start_date: start_date, 
          end_date: end_date, months_of_work: months_of_work)
        emp_history.create_note(summary: org_summary)
      end
      
    end
    

  end

  
end





#bundle exec rake  elasticsearch:resume_xml_to_json

  


 
