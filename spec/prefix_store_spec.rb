# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PrefixStore do
  it 'has a version number' do
    expect(PrefixStore::VERSION).not_to be nil
  end
end
