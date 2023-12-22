require 'spec_helper'
describe 'drush' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('drush') }
  end
end
