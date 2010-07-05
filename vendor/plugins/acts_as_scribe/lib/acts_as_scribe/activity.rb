class Activity < ActiveRecord::Base
  scope :by_user, lambda { |users|
     where(:user_id => users)
  }

  scope :by_action, lambda { |action|
     where(:action => action.to_s)
  }

  scope :by_item, lambda { |item|
    where(item_type => item.class.name, :item_id => item.id)
  }
  
  scope :created_since, lambda { |time_ago| 
    where(['created_at > ?', time_ago])
  }
    
  if defined?(User)
    belongs_to :user
    validates_presence_of :user_id
  end
  
  belongs_to :item, :polymorphic => true
  

  def self.created_by(user)
    raise "Activity.created_by(user) has been deprecated. Use Activity.by_user(user) instead."
  end

  def self.without_model_created_by(user)
    raise "Activity.without_model_created_by(user) has been deprecated. Use Activity.by_user(user) and filter the results instead."
  end

  def without_model?
    item.nil?
  end
  
  def self.report(user, action, object=nil)
    returning Activity.new do |a|
      a.item = object if object
      a.action = action.to_s
      if defined?(User)
        a.user = user
      else
        a.user_id = 0
      end
      a.save!
    end
  end

end