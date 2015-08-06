shared_examples_for 'an endpoint with token_authentication!' do |route_pairs|
  route_pairs.each do |route_pair|
    it "returns 401 for #{route_pair[0].upcase} #{route_pair[1]}" do
      send route_pair[0], route_pair[1]
      expect(response_code).to eq 401
    end
  end
end
