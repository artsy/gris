module Gris
  module RspecExtensions
    module ResponseHelpers
      def response_code
        last_response.status
      end

      def response_body
        last_response.body
      end

      def parsed_response
        Hashie::Mash.new(JSON.parse(last_response.body))
      end

      def result
        parsed_response
      end

      def embedded_results(klass)
        parsed_response[:_embedded][klass.name.tableize.to_sym]
      end

      def embedded_results_count(klass)
        embedded_results(klass).count
      end

      def expect_embedded_results_count_of(count, klass)
        expect(embedded_results_count(klass)).to eq(count)
      end

      def first_embedded_result(klass)
        embedded_results(klass).first
      end

      def embedded_result_with_id(id, klass)
        embedded_results(klass).detect { |r| r.id == id }
      end

      def links
        parsed_response['_links']
      end

      def link_to_self
        links['self']
      end

      def link_to_next
        links['next']
      end

      def link_to_previous
        links['prev']
      end
    end
  end
end
