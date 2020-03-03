# coding: utf-8

class CarwashDecorator < ApplicationDecorator
  delegates_all # or some fields

  def pretty_title
    "&laquo;#{title}&raquo; #{address}".html_safe
  end

  def url_string
    url.blank? ? '' : url.gsub('http://', '').gsub('www.', '')
  end
end
