class OrdersController < ApplicationController
  before_action :fetch_order, only: :show, if: :order_present_in_users_orders?
  before_action :new_order, only: :create
  before_action :fetch_users_orders, only: :index, if: :user_orders

  def new
    @order = Order.new
  end

  def create
    if @order.save
      remove_product_id
      user_orders << @order.id.to_s
      flash[:new_order] = true
      send_notifications

      redirect_to @order
    else
      flash.now[:error] = "Необходимо заполнить поля подсвеченные красным"
      render :new
    end
  end

  def index
  end

  def show
    render :file => "public/404.html", :layout => false, :status => 404 if @order.blank?
  end

  private

  def new_order
    @order = Order.new(params[:order])
    new_product_order_items
  end

  def fetch_users_orders
    @orders ||= Order.find(user_orders)
    user_orders_update(@orders)
  end

  def fetch_order
    @order ||= Order.find(params[:id])
  end

  def order_present_in_users_orders?
    user_orders.include?(params[:id])
  end

  def new_product_order_items
    basket.products.each do |product|
      @order.order_items << OrderItem.new(
        :product_id  => product.id,
        :product_uid => product.uid,
        :count       => basket.product_count(product),
        :cost        => basket.product_cost(product)
      )
    end
  end

  def user_orders
    (session[:orders] ||= []) # .select{|o| o.to_s.size > 20}
  end

  def user_orders_update(orders)
    session[:orders] = orders.map(&:id).map(&:to_s)
  end

  def send_notifications
    config_mailers
    deliver_new_order_notification

    send_sms_notification if app_settings.gcal_sms_notifier
  end

  def config_mailers
    @mail_config = app_settings.mail_config || 'office@example.com'
    ActionMailer::Base.smtp_settings = SMTP_SETTINGS[@mail_config]
  end

  def deliver_new_order_notification
    Notifier.deliver_new_order_notification(
      @order,
      render_to_string(:template => 'admin/orders/show.xls', :layout => false),
      @mail_config
    )
  end

  def send_sms_notification
    logger.info "Sending SMS Notification"
    SmsNotifier.send_new_order_notification(@order,
      :gcal_login    => 'office@example.com',
      :gcal_password => SMTP_SETTINGS['office@example.com'][:password]
    ) rescue logger.error("SmsNotifier error")
  end

  def remove_product_id
    @order.order_items.each {|i| basket.remove_product_id(i.product_id) }
  end
end
