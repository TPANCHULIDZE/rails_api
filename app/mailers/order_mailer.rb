class OrderMailer < ApplicationMailer
  default from: "tpanchulidze@unisens.ge"
  def send_confirmation(order)
    user = order.user
    mail to: user.email, subject: "Order Confirmation"
  end
end
