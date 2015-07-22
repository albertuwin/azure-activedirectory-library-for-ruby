#-------------------------------------------------------------------------------
# # Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS
# OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
# ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A
# PARTICULAR PURPOSE, MERCHANTABILITY OR NON-INFRINGEMENT.
#
# See the Apache License, Version 2.0 for the specific language
# governing permissions and limitations under the License.
#-------------------------------------------------------------------------------

require_relative '../spec_helper'

describe ADAL::MexRequest do
  describe '#initialize' do
    context 'with an invalid endpoint' do
      let(:uri) { 'not a uri' }

      it 'should raise an error' do
        expect { ADAL::MexRequest.new(uri) }.to raise_error(
          URI::InvalidURIError)
      end
    end
  end

  describe '#execute' do
    let(:response_body) { 'response body' }
    let(:uri) { 'https://abc.def/' }

    before(:each) do
      @http_request = nil
      expect_any_instance_of(Net::HTTP).to receive(:request) do |_, req|
        @http_request = req
      end.and_return(double(body: response_body))
      expect(ADAL::MexResponse).to receive(:parse)
      ADAL::MexRequest.new(uri).execute
    end

    describe 'http request' do
      subject { @http_request }

      it { expect(subject['Content-Type']).to eq 'application/soap+xml' }
      it { expect(subject.path).to eq '/' }
    end
  end
end
