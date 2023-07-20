class InvoiceLists::DestroysController < CrudController
  skip_authorization_check
  skip_authorize_resource

  respond_to :js, only: [:show]

  helper_method :deletable?

  def destroy
    authorize!(:destroy, entry)

    raise ActiveRecord::RecordInvalid unless deletable? # is there a better error?

    super
  end

  def show
    @message = entry.message
    non_draft_invoice_present
  end

  def self.model_class
    InvoiceList
  end

  private

  def destroy_return_path(destroyed, options = {})
    group_invoice_lists_path(entry.group)
  end

  def full_entry_label
    "#{models_label(false)} <i>#{entry.title}</i>".html_safe # rubocop:disable Rails/OutputSafety
  end

  def deletable?
    !non_draft_invoice_present
  end

  def non_draft_invoice_present
    @non_draft_invoice_present ||= entry.invoices.any? { |i| !(i.draft? || i.cancelled?) }
  end

  def entry
    @entry ||= InvoiceList.find(params[:invoice_list_id])
  end

  def group
    @group ||= Group.find(params[:group_id])
  end
end
