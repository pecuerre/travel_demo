module Master

    class Response

      attr_reader :resources, :messages

      # Creates a new Response object, which standardizes the response received From Expedia.
      def initialize(resources, messages = [])
        @resources = resources
        @messages = messages
      end

      def errors?
        @messages.any?
      end

    end

end
