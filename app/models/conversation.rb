class Conversation < ActiveRecord::Base

  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User' 

  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, :scope => :recipient_id

  scope :between, -> (sender_id,recipient_id) do
    where(
      "(conversations.sender_id = ? AND conversations.recipient_id =?) 
      OR (conversations.sender_id = ? AND conversations.recipient_id =?)", 
      sender_id, recipient_id, recipient_id, sender_id)
  end
  scope :get_all, ->(current_user) { where("(conversations.sender_id = ? OR conversations.recipient_id = ?)", current_user, current_user) }
  
  scope :get_conversation, ->(user_id, conversation_id) do
    where("(conversations.sender_id = ? OR conversations.recipient_id =?) AND id = ?", 
      user_id, user_id, conversation_id) 
  end
end