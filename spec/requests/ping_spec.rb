# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'All type of requests', type: :request do
  describe 'handle pings' do
    context 'save_ping' do
      it 'should save ping if proxy is true' do
        get 'http://localhost:3000/v2/traffics?proxy=true&type=static&app_id=2323'
        expect(Ping.count).to eq(1)
      end

      it 'should not save ping if proxy is not true or not present' do
        post 'http://localhost:3000/v2/traffics', params: { proxy: true, type: 'static', app_id: '2323' }
        expect(Ping.count).to eq(1)
      end
    end

    context 'different request types' do
      it 'should receive valid response from mocky with GET request type' do
        get 'http://localhost:3000/v2/traffics?proxy=true&type=static&app_id=2323'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq('hello' => 'world')
      end

      it 'should receive valid response from mocky with POST request type' do
        post 'http://localhost:3000/v2/traffics', params: { proxy: true, type: 'static', app_id: '2323' }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq('hello' => 'world')
      end

      it 'should receive valid response from mocky with invalid parameters' do
        post 'http://localhost:3000/v2/traffics', params: { type_random: 'random' }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq('hello' => 'world')
      end
    end
  end
end
