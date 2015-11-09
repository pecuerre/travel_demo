# Only run this script if the spree_measures table has no values.
# Optionally you could always alter this script to add the missing values.

namespace :db do
  desc "Loads question groups"
  task :load_question_groups => :environment do
    
    delete_all = (ENV['DELETE_ALL'] || false).to_b
    debug = (ENV['DEBUG'] || false).to_b

    if delete_all
      Spree::QuestionGroup.delete_all
      Spree::Question.delete_all
      Spree::AnswerGroup.delete_all
      Spree::Answer.delete_all
    end
    
    countries = Spree::Country.all.order(:name).map(&:name).join("\n")

    question_groups_attributes = [
      {
          name: Spree::Pax::QUESTION_GROUP_FLIGHT_PAX_INFO,
          position: 1,
          questions_attributes: [
            {
              type: 'Spree::Questions::Date',
              label: Spree::Pax::QUESTION_BIRTHDAY,
              question_text: 'Date of Birthday',
              validation_rules: { presence: true },
              position: 1,
            },
            {
              type: 'Spree::Questions::Select',
              label: Spree::Pax::QUESTION_AUTHORIZED_CATEGORIES,
              question_text: 'I certified that this trip to Cuba complies with one of the following 12 categories of authorized travel as described by the U.S. government. The purpose of this trip is:',
              answer_options: "Educational activities in Cuba for schools, including people-to-people exchanges open to everyone
            Professional research and professional meetings in Cuba
            Public performances, clinics, workshops, athletic and other competitions, and exhibitions in Cuba
            Religious activities in Cuba
            Humanitarian projects in Cuba
            Journalistic activities in Cuba
            Family visits to close relatives in Cuba
            Activities in Cuba by private foundations, or research or educational institutes
            Any type of support for the Cuban people
            Exportation, importation, or transmission of information technologies or materials
            Certain authorized export transactions including agricultural and medical products, and tools, equipment and construction supplies for private use
            Official business of the US government, foreign governments, and certain intergovernmental organizations",
              position: 10,
              validation_rules: { presence: true, include_blank: true }
            },
            {
              type: 'Spree::Questions::Select',
              label: Spree::Pax::QUESTION_FLIGHT_CLEARANCE_AIRPORT,
              question_text: 'Clerance Airport',
              answer_options: "Atlantic City International Airport
              Baltimore Washington International Airpo
              Jose Marti International Airport
              Logan International Airport
              Miami International Airport
              Nashville International Airport
              Orlando International Airport
              Punta Cana International Airport
              Southwest Florida International",
              position: 1,
              validation_rules: { presence: true, include_blank: true }
            },
            {
              type: 'Spree::Questions::Select',
              label: Spree::Pax::QUESTION_FLIGHT_NACIONALITY,
              question_text: 'Nacionality',
              answer_options: countries,
              position: 2,
              validation_rules: { presence: true, include_blank: true }
            },
            {
              type: 'Spree::Questions::Short',
              label: Spree::Pax::QUESTION_FLIGHT_DESTINATION_CITY,
              question_text: 'Destination City',
              position: 3,
              validation_rules: { presence: true }
            },
            {
              type: 'Spree::Questions::Select',
              label: Spree::Pax::QUESTION_FLIGHT_RESIDENT_COUNTRY,
              question_text: 'Resident Country',
              answer_options: countries,
              position: 4,
              validation_rules: { presence: true, include_blank: true }
            },
            {
              type: 'Spree::Questions::Select',
              label: Spree::Pax::QUESTION_FLIGHT_DESTINATION_COUNTRY,
              question_text: 'Destination Country',
              answer_options: countries,
              position: 5,
              validation_rules: { presence: true, include_blank: true }
            },
            {
              type: 'Spree::Questions::Short',
              label: Spree::Pax::QUESTION_FLIGHT_DESTINATION_ZIP,
              question_text: 'Destination ZIP Code',
              position: 6
            },
            {
              type: 'Spree::Questions::Short',
              label: Spree::Pax::QUESTION_FLIGHT_DESTINATION_EMAIL,
              question_text: 'Destination Email',
              position: 7,
              validation_rules: { presence: true }
            },
            {
              type: 'Spree::Questions::Short',
              label: Spree::Pax::QUESTION_FLIGHT_DESTINATION_PHONE,
              question_text: 'Destination Phone Number',
              position: 8,
              validation_rules: { presence: true }
            }
          ]
      }
    ]

    question_attributes = Spree::Question.attribute_names
    default_question_attributes = HashWithIndifferentAccess.new(Spree::Question.new.attributes).except(:id, :question_group_id, :created_at, :updated_at)

    question_groups_attributes.each do |qgattr|
      qgroup = Spree::QuestionGroup.find_by_name(qgattr[:name])
      if qgroup.present?
        qgroup.assign_attributes(qgattr.except(:questions_attributes))
        if qgroup.changed?
          puts "Updating question group #{qgroup.id}: #{qgroup.name} - #{qgroup.changed.map{|a| "#{a}: #{qgroup.send(a.to_sym)}"}.join(', ')}"
          qgroup.save! unless debug
        end
        qgattr[:questions_attributes].each do |qattr|
          # lookup by label first, then question_text
          q = qgroup.questions.where(label: qattr[:label]).first ||
              qgroup.questions.where(question_text: qattr[:question_text]).first
          if q.present?
            updated_attrs = []
            attrs = default_question_attributes.merge(qattr)
            q.assign_attributes(attrs)
            if q.changed?
              updated_attrs = q.changed.map{|a| "#{a}: #{attrs[a.to_sym]}"}.join(', ')
              puts "Updating question id #{q.id}: #{q.question_text} - #{updated_attrs}"
              q.save! unless debug
            end
          else
            puts "Creating question: #{qattr[:question_text]}"
            qgroup.questions.create!(qattr) unless debug
          end
        end
      else
        puts "Creating question group #{qgattr[:name]}"
        qgroup = Spree::QuestionGroup.create!(qgattr) unless debug
      end
    end
  end
end
