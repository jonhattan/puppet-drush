require 'spec_helper'

describe 'drush' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "drush class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('drush') }
        end
      end
    end
  end
end
