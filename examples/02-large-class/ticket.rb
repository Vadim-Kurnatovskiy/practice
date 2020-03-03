# coding: utf-8

class Ticket < ActiveRecord::Base
  belongs_to :carwash

  scope :with_open_status, -> { where(status: Ticket::OPEN) }
  scope :with_new_status, -> { where(status: Ticket::NEW) }
  scope :by_date, -> { order(date: :desc, start_time: :asc) }
end
