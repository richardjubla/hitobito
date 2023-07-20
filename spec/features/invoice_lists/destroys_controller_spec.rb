

require 'spec_helper'

describe InvoiceLists::DestroysController do
  let(:layer) { groups(:top_layer) }

  let(:draft_invoices) do
    [0..10].map do
      Fabricate(:invoice, due_at: 10.days.from_now, creator: people(:top_leader), state: :draft, recipient: people(:bottom_member), group: layer)
    end
  end

  let!(:invoice_list) { InvoiceList.create(title: 'membership fee', invoices: draft_invoices, group: layer) }

  let(:user) { people(:top_leader) }
  before { sign_in(user) }

  context 'for invoice list with only draft invoices' do
    it 'shows modal with confirm text' do
      visit group_invoice_lists_path(layer)

      table = page.all('table')[0]

      expect(table).to have_content(/membership fee/)
      table.find('td a[title="Löschen"]').click

      expect(page).to have_text(/Wollen Sie die Sammelrechnung wirklich löschen?/)

      modal = page.find('#invoice-list-destroy')

      expect do
        modal.find('button[type="submit"]').click
      end.to change { InvoiceList.count }.by(-1)
    end
  end

  context 'for invoice list with not only draft invoices' do
    before { draft_invoices.sample.update!(state: :sent) }

    it 'shows modal with confirm text' do
      visit group_invoice_lists_path(layer)

      table = page.all('table')[0]

      expect(table).to have_content(/membership fee/)
      table.find('td a[title="Löschen"]').click

      expect(page).to have_text('In der Sammelrechnung ist mindesents eine Rechnung enthalten, welche weder den Status "Entwurf" noch "Storniert" hat. Daher kann die Sammelrechnung nicht gelöscht werden.')

      modal = page.find('#invoice-list-destroy')

      expect(modal).to have_css('button[type="submit"][disabled="disabled"]')
    end
  end
end
