# frozen_string_literal: true

require 'spec_helper'

describe IcontrolRest::Client do
  let(:api) { IcontrolRest::Client.new(host: '1.2.3.4', user: 'user', pass: 'pass', verify_cert: false) }
  let(:bad_response) { double('Object', code: 500, :[] => '') }

  describe '#get/post/put/delete' do
    context 'when an empty route chain is passed' do
      it 'raises StandardError' do
        expect { api.get_ }.to raise_error StandardError
      end
    end

    context 'when anything but a 200 is returned from the F5' do
      it 'raises an exception' do
        allow(IcontrolRest::Client).to receive(:get).and_return bad_response
        expect { api.get_sys_dns }.to raise_error StandardError
      end
    end
  end

  describe '#get' do
    context 'when anything but a 200 is returned from the F5' do
      it 'raises an exception' do
        allow(IcontrolRest::Client).to receive(:get).and_return bad_response
        expect { api.get('/mgmt/tm/sys/dns') }.to raise_error StandardError
      end
    end
  end

  describe '#post' do
    context 'when anything but a 200 is returned from the F5' do
      it 'raises an exception' do
        allow(IcontrolRest::Client).to receive(:post).and_return bad_response
        expect { api.post('/mgmt/tm/sys/dns', key: 'thing') }.to raise_error StandardError
      end
    end
  end
end
