# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe 'Dropdown::PeopleExport' do
  include Rails.application.routes.url_helpers


  include FormatHelper
  include LayoutHelper
  include UtilityHelper

  let(:user) { people(:top_leader) }
  let(:dropdown) do
    Dropdown::PeopleExport.new(self,
                               user,
                               { controller: 'people', group_id: groups(:top_group).id },
                               households: true, labels: true, emails: true,
                               mailchimp_synchronization_path: 'mailchimp.example.com')
  end

  subject { dropdown.to_s }

  def can?(*args)
    true
  end

  it 'renders dropdown' do
    is_expected.to have_content 'Export'
    is_expected.to have_selector 'ul.dropdown-menu'
    is_expected.to have_selector 'li', text: 'CSV'
    is_expected.to have_selector 'li', text: 'Haushaltsliste'

    is_expected.to have_selector 'li', text: 'Etiketten'
    is_expected.to have_selector 'li ul.dropdown-menu', text: 'Standard'

    is_expected.to have_selector 'a', text: 'vCard'

    is_expected.to have_selector 'a', text: 'MailChimp'

    is_expected.to have_selector 'a', text: 'E-Mail Adressen'

    is_expected.to have_selector 'a', text: 'E-Mail Adressen (Outlook)'
  end

  context 'for global labels' do
    before :each do
      Fabricate(:label_format, name: 'SampleFormat')
    end

    it 'includes global formats if Person#show_global_label_formats is true' do
      user.update(show_global_label_formats: true)

      is_expected.to include 'SampleFormat'
    end

    it 'excludes global formats if Person#show_global_label_formats is false' do
      user.update(show_global_label_formats: false)

      is_expected.not_to include 'SampleFormat'
    end
  end
end
