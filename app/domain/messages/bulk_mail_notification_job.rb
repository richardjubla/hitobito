# frozen_string_literal: true

# Copyright (c) 2012-2021, Hitobito AG. This file is part of
# hitobito and licensed under the Affero General Public License version 3
# or later. See the COPYING file at the top-level directory or at
# https://github.com/hitobito/hitobito.

class Messages::BulkMailNotificationJob
  self.parameters = [:message, :reason]

  def initialize(message, reason)
    @message = message
    @reason = reason
  end

  def perform

  end

end
