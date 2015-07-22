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

require_relative '../support/fake_data'
require_relative '../spec_helper'

include FakeData

describe ADAL::CachedTokenResponse do
  let(:authority) { AUTHORITY }
  let(:client) { ADAL::ClientCredential.new(CLIENT_ID) }
  let(:resource) { RESOURCE }
  let(:refresh_token) { REFRESH_TOKEN }
  let(:response) do
    ADAL::SuccessResponse.new(resource: resource, refresh_token: refresh_token)
  end

  describe '#mrrt?' do
    subject { ADAL::CachedTokenResponse.new(client, authority, response) }

    context 'with a refresh_token' do
      let(:refresh_token) { REFRESH_TOKEN }

      context 'with a resource' do
        let(:resource) { RESOURCE }
        it { is_expected.to be_mrrt }
      end

      context 'without a resource' do
        let(:resource) { nil }
        it { is_expected.to_not be_mrrt }
      end
    end

    context 'wihout a refresh_token' do
      let(:refresh_token) { nil }

      context 'with a resource' do
        let(:resource) { RESOURCE }
        it { is_expected.to_not be_mrrt }
      end

      context 'without a resource' do
        let(:resource) { nil }
        it { is_expected.to_not be_mrrt }
      end
    end
  end

  describe '#can_refresh?' do
    let(:other) { ADAL::CachedTokenResponse.new(client, oauthority, response) }
    subject do
      ADAL::CachedTokenResponse.new(client, authority, response)
        .can_refresh?(other)
    end

    context 'when not an mrrt' do
      let(:oauthority) { authority }
      let(:refresh_token) { nil }

      it { is_expected.to be_falsey }
    end

    context 'when an mrrt' do
      context 'when fields match' do
        let(:oauthority) { authority }
        it { is_expected.to be_truthy }
      end

      context 'when fields do not match' do
        let(:oauthority) { 'some other authority' }
        it { is_expected.to be_falsey }
      end
    end
  end

  it 'provides proxy access to token response fields' do
    expect(
      ADAL::CachedTokenResponse.new(client, AUTHORITY, response).resource
    ).to eq RESOURCE
  end
end
