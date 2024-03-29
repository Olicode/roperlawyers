class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true

  validates :last_name, presence: true, on: :update
  has_one_attached :nie_document
  has_one_attached :passport_document

  after_create_commit :send_updates_to_admin
  after_update_commit :send_updates_to_admin

  private

  def send_updates_to_admin
    puts "*" * 100
    puts "sending email to admin"
    puts "*" * 100
    # TODO: uncomment when sendgrid email starts working.
    # AdminMailer.send_user_updates(self).deliver_now
  end
end
