require 'spec_helper'
describe 'drush' do

  context 'with defaults for all parameters' do
    it { should contain_class('drush') }
  end
end
