# coding: utf-8

class Carwash < ActiveRecord::Base
  validates :title, :slug, :address, :start_time, :end_time, :presence => true

  mount_uploader :logo, LogoUploader

  belongs_to :area
  belongs_to :city
  belongs_to :owner, :class_name => 'User'

  has_many :users
  has_many :clients
  has_many :boxes
  has_many :price_groups
  has_many :services
  has_many :photos
  has_many :tickets

  default_scope where(locked: false, enabled: true)


  #def timeline(date, time, opts = {})
    #CarwashTimeline.new(self, date, time, opts)
  #end

  def new_tickets # in decorator?
    tickets.with_new_status.by_date
  end

  def open_tickets # in decorator?
    tickets.with_open_status.by_date
  end

  def start_time_string
    self.start_time.strftime('%H:%M')
  end

  def start_time_string=(start_time_string)
    self.start_time = Time.zone.parse(start_time_string)
  end

  def end_time_string
    self.end_time.strftime('%H:%M')
  end

  def end_time_string=(end_time_string)
    self.end_time = Time.zone.parse(end_time_string)
  end

  def all_day_long?
    true if self.start_time.strftime('%H:%M') == "00:00" && self.end_time.in_minutes > 1400
  end

  def open_at_time?(s_time)
    s_time.in_minutes > self.end_time.in_minutes || s_time.in_minutes < self.start_time.in_minutes ? false : true
  end

  def boxes_with_tickets_for_date(date = nil)
    bxs = self.boxes.all
    return {} if bxs.empty?
    tickets = Ticket.for_date(date).where(:box_id => bxs.collect(&:id)).all
    rs = {}
    bxs.each {|b| rs[b] = tickets.find_all {|t| t.box_id == b.id}}

    rs
  end

  def visible_boxes_with_tickets_for_date(date = nil)
    bxs = self.boxes.where(visible_in_search_results: true).all
    return {} if bxs.empty?
    tickets = Ticket.for_date(date).where(:box_id => bxs.collect(&:id)).all
    rs = {}
    bxs.each {|b| rs[b] = tickets.find_all {|t| t.box_id == b.id}}

    rs
  end
end
