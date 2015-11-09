Spree::Pax.class_eval do
    has_many :answer_groups, inverse_of: :pax, dependent: :destroy
    has_many :answers, through: :answer_groups
    has_many :questions, through: :answer_groups
    
    QUESTION_GROUP_FLIGHT_PAX_INFO = 'Flight pax info'
    QUESTION_BIRTHDAY = 'Question date of Birthday'
    QUESTION_AUTHORIZED_CATEGORIES = 'Authorized Categories to travel to Cuba'
    QUESTION_FLIGHT_CLEARANCE_AIRPORT = 'Question flight clerance airport'
    QUESTION_FLIGHT_NACIONALITY = 'Question flight nacionality'
    QUESTION_FLIGHT_DESTINATION_CITY = 'Question flight destination city'
    QUESTION_FLIGHT_RESIDENT_COUNTRY = 'Question flight resindent country'
    QUESTION_FLIGHT_DESTINATION_COUNTRY = 'Question flight destination country'
    QUESTION_FLIGHT_RESIDENT_COUNTRY = 'Question flight resident country'
    QUESTION_FLIGHT_DESTINATION_COUNTRY = 'Question flight destination airport'
    QUESTION_FLIGHT_DESTINATION_ZIP = 'Question flight destination zip'
    QUESTION_FLIGHT_DESTINATION_EMAIL = 'Question flight destination email'
    QUESTION_FLIGHT_DESTINATION_PHONE = 'Question flight destination phone'
end